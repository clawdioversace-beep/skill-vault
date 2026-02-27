#!/usr/bin/env bash
# Compose a tweet announcing a new skill
# Usage: bash scripts/compose-skill-tweet.sh skills/skill-name
# Outputs the tweet text to stdout

set -euo pipefail

SKILL_DIR="${1:?Usage: compose-skill-tweet.sh <skill-directory>}"
REPO_URL="${REPO_URL:-https://github.com/clawdioversace-beep/skill-vault}"

SKILL_NAME=$(basename "$SKILL_DIR")
SKILL_MD="$SKILL_DIR/SKILL.md"
README_MD="$SKILL_DIR/README.md"

# Extract pitch from README first line after "# "
PITCH=""
if [ -f "$README_MD" ]; then
  # Get the line after the first heading, skip blank lines
  PITCH=$(awk '/^# /{found=1; next} found && /^$/{next} found{print; exit}' "$README_MD")
fi

# Fallback: extract from SKILL.md description
if [ -z "$PITCH" ] && [ -f "$SKILL_MD" ]; then
  PITCH=$(python3 -c "
import re
content = open('$SKILL_MD').read()
match = re.search(r'description:\s*>?\s*\n?\s*(.+?)(?:\n\s{2,}|\n[a-z]|\n---)', content, re.MULTILINE)
if match:
    print(match.group(1).strip()[:200])
else:
    match = re.search(r'description:\s*(.+)', content, re.MULTILINE)
    if match: print(match.group(1).strip()[:200])
" 2>/dev/null || echo "A new Claude skill")
fi

# Extract tier
TIER="Free"
if [ -f "$README_MD" ]; then
  if grep -qi "premium" "$README_MD"; then TIER="Premium"; fi
  if grep -qi "enterprise" "$README_MD"; then TIER="Enterprise"; fi
fi

# Count evals
EVAL_COUNT=0
if [ -f "$SKILL_DIR/evals/evals.json" ]; then
  EVAL_COUNT=$(python3 -c "
import json
data = json.load(open('$SKILL_DIR/evals/evals.json'))
print(len(data.get('evals', [])))
" 2>/dev/null || echo "0")
fi

# Compose tweet (max 280 chars)
# Format: New skill dropped → skill-name
# [pitch]
# [evals] evals passing | [tier]
# [link] #ClaudeCode #AI
TWEET="New skill dropped in the vault: ${SKILL_NAME}

${PITCH}

${EVAL_COUNT} evals passing | ${TIER}
${REPO_URL}/tree/main/skills/${SKILL_NAME}

#ClaudeCode #AI #DeveloperTools"

# Truncate if over 280
if [ ${#TWEET} -gt 280 ]; then
  # Shorten the pitch
  MAX_PITCH=$((280 - ${#TWEET} + ${#PITCH} - 3))
  if [ "$MAX_PITCH" -gt 20 ]; then
    SHORT_PITCH="${PITCH:0:$MAX_PITCH}..."
    TWEET="New skill dropped in the vault: ${SKILL_NAME}

${SHORT_PITCH}

${EVAL_COUNT} evals passing | ${TIER}
${REPO_URL}/tree/main/skills/${SKILL_NAME}

#ClaudeCode #AI #DeveloperTools"
  fi
fi

echo "$TWEET"
