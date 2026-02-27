#!/usr/bin/env bash
# Compose a weekly digest tweet + Reddit post draft
# Usage: bash scripts/compose-weekly-digest.sh
# Outputs: tweet to stdout, saves reddit draft to /tmp/weekly-digest-reddit.md

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_URL="${REPO_URL:-https://github.com/clawdioversace-beep/skill-vault}"

cd "$REPO_ROOT"

# Find skills added in the last 7 days
NEW_SKILLS=()
SINCE=$(date -v-7d +%Y-%m-%dT00:00:00 2>/dev/null || date -d '7 days ago' +%Y-%m-%dT00:00:00 2>/dev/null || echo "")

if [ -n "$SINCE" ]; then
  while IFS= read -r line; do
    # Extract skill directory names from added files
    skill_name=$(echo "$line" | grep "^skills/" | cut -d/ -f2 | sort -u)
    if [ -n "$skill_name" ] && [ -d "skills/$skill_name" ]; then
      NEW_SKILLS+=("$skill_name")
    fi
  done < <(git log --since="$SINCE" --diff-filter=A --name-only --pretty=format: -- 'skills/*/SKILL.md' | sort -u)
fi

TOTAL_SKILLS=$(ls -d skills/*/ 2>/dev/null | wc -l | tr -d ' ')
NEW_COUNT=${#NEW_SKILLS[@]}

if [ "$NEW_COUNT" -eq 0 ]; then
  echo "No new skills this week. Skipping digest."
  exit 0
fi

# Build skill list for tweet
SKILL_LIST=""
for s in "${NEW_SKILLS[@]}"; do
  [ -n "$s" ] && SKILL_LIST="$SKILL_LIST  $s\n"
done

# Compose tweet
TWEET="Skill Vault weekly: ${NEW_COUNT} new skill(s) this week

$(echo -e "$SKILL_LIST")
${TOTAL_SKILLS} total skills, all tested with evals

Browse: ${REPO_URL}

#ClaudeCode #AI #DeveloperTools"

# Truncate if needed
if [ ${#TWEET} -gt 280 ]; then
  TWEET="Skill Vault weekly: ${NEW_COUNT} new skill(s) this week

${TOTAL_SKILLS} total skills, all tested with evals

Browse & contribute: ${REPO_URL}

#ClaudeCode #AI"
fi

echo "$TWEET"

# Generate Reddit post draft
REDDIT_BODY="# Skill Vault Weekly — $(date +%b\ %d,\ %Y)

**${NEW_COUNT} new skill(s) this week** | **${TOTAL_SKILLS} total** | All tested with evals

## New This Week

"

for s in "${NEW_SKILLS[@]}"; do
  if [ -n "$s" ] && [ -f "skills/$s/README.md" ]; then
    PITCH=$(awk '/^# /{found=1; next} found && /^$/{next} found{print; exit}' "skills/$s/README.md")
    REDDIT_BODY="$REDDIT_BODY- **[$s](${REPO_URL}/tree/main/skills/$s)** — $PITCH
"
  fi
done

REDDIT_BODY="$REDDIT_BODY
## What is Skill Vault?

Curated, tested Claude skills that actually work. Every skill has 3+ evals, pushy trigger descriptions, and meets a quality bar. No junk.

**Install any skill:**
\`\`\`bash
cp -r skills/skill-name ~/.claude/skills/
\`\`\`

**Contribute:** Fork, add your skill, open a PR. CI validates automatically.

**Repo:** ${REPO_URL}
"

DIGEST_FILE="/tmp/weekly-digest-reddit.md"
echo "$REDDIT_BODY" > "$DIGEST_FILE"
echo "(Reddit draft saved to $DIGEST_FILE)" >&2
