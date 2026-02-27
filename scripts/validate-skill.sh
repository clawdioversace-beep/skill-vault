#!/usr/bin/env bash
# Validate a skill directory meets the quality bar
# Usage: bash scripts/validate-skill.sh skills/skill-name

set -euo pipefail

SKILL_DIR="${1:?Usage: validate-skill.sh <skill-directory>}"
ERRORS=0

red()   { echo -e "\033[31m✗ $1\033[0m"; }
green() { echo -e "\033[32m✓ $1\033[0m"; }
warn()  { echo -e "\033[33m⚠ $1\033[0m"; }

echo "Validating: $SKILL_DIR"
echo "---"

# Check directory exists
if [ ! -d "$SKILL_DIR" ]; then
  red "Directory not found: $SKILL_DIR"
  exit 1
fi

# Check required files
for file in SKILL.md evals/evals.json README.md; do
  if [ -f "$SKILL_DIR/$file" ]; then
    green "$file exists"
  else
    red "$file missing"
    ERRORS=$((ERRORS + 1))
  fi
done

# Check SKILL.md has frontmatter
if [ -f "$SKILL_DIR/SKILL.md" ]; then
  if head -1 "$SKILL_DIR/SKILL.md" | grep -q "^---"; then
    green "SKILL.md has YAML frontmatter"
  else
    red "SKILL.md missing YAML frontmatter (must start with ---)"
    ERRORS=$((ERRORS + 1))
  fi

  # Check name field
  if grep -q "^name:" "$SKILL_DIR/SKILL.md"; then
    green "SKILL.md has name field"
  else
    red "SKILL.md missing name field"
    ERRORS=$((ERRORS + 1))
  fi

  # Check description field
  if grep -q "^description:" "$SKILL_DIR/SKILL.md"; then
    green "SKILL.md has description field"
  else
    red "SKILL.md missing description field"
    ERRORS=$((ERRORS + 1))
  fi

  # Check line count
  LINES=$(wc -l < "$SKILL_DIR/SKILL.md")
  if [ "$LINES" -le 500 ]; then
    green "SKILL.md is $LINES lines (max 500)"
  else
    red "SKILL.md is $LINES lines (exceeds 500 line limit)"
    ERRORS=$((ERRORS + 1))
  fi

  # Check for examples
  if grep -qi "example" "$SKILL_DIR/SKILL.md"; then
    green "SKILL.md contains examples"
  else
    warn "SKILL.md may not contain examples (no 'example' keyword found)"
  fi
fi

# Check evals
if [ -f "$SKILL_DIR/evals/evals.json" ]; then
  # Check valid JSON
  if python3 -c "import json; json.load(open('$SKILL_DIR/evals/evals.json'))" 2>/dev/null; then
    green "evals.json is valid JSON"
  else
    red "evals.json is not valid JSON"
    ERRORS=$((ERRORS + 1))
  fi

  # Check eval count
  EVAL_COUNT=$(python3 -c "
import json
data = json.load(open('$SKILL_DIR/evals/evals.json'))
print(len(data.get('evals', [])))
" 2>/dev/null || echo "0")

  if [ "$EVAL_COUNT" -ge 3 ]; then
    green "evals.json has $EVAL_COUNT evals (min 3)"
  else
    red "evals.json has $EVAL_COUNT evals (need at least 3)"
    ERRORS=$((ERRORS + 1))
  fi

  # Check each eval has required fields
  MISSING_FIELDS=$(python3 -c "
import json
data = json.load(open('$SKILL_DIR/evals/evals.json'))
missing = 0
for e in data.get('evals', []):
    for field in ['id', 'prompt', 'expectations']:
        if field not in e:
            missing += 1
            print(f'  Eval missing field: {field}')
print(f'TOTAL:{missing}')
" 2>/dev/null || echo "TOTAL:1")

  MISSING=$(echo "$MISSING_FIELDS" | grep "TOTAL:" | cut -d: -f2)
  if [ "$MISSING" = "0" ]; then
    green "All evals have required fields (id, prompt, expectations)"
  else
    red "Some evals missing required fields"
    echo "$MISSING_FIELDS" | grep -v "TOTAL:"
    ERRORS=$((ERRORS + 1))
  fi
fi

# Check directory name is kebab-case
DIR_NAME=$(basename "$SKILL_DIR")
if echo "$DIR_NAME" | grep -qE '^[a-z][a-z0-9]*(-[a-z0-9]+)*$'; then
  green "Directory name is kebab-case: $DIR_NAME"
else
  red "Directory name should be kebab-case: $DIR_NAME"
  ERRORS=$((ERRORS + 1))
fi

echo "---"
if [ "$ERRORS" -eq 0 ]; then
  green "All checks passed!"
  exit 0
else
  red "$ERRORS check(s) failed"
  exit 1
fi
