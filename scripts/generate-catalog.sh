#!/usr/bin/env bash
# Generate the skills catalog table for README.md
# Reads all skills/*/SKILL.md and builds a markdown table
# Usage: bash scripts/generate-catalog.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
README="$REPO_ROOT/README.md"

# Build catalog entries
CATALOG=""
for skill_dir in "$SKILLS_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  skill_md="$skill_dir/SKILL.md"
  readme_md="$skill_dir/README.md"

  [ -f "$skill_md" ] || continue

  # Extract description first line from SKILL.md frontmatter
  description=$(python3 -c "
import re, sys
content = open('$skill_md').read()
match = re.search(r'^description:\s*>?\s*\n?\s*(.+?)(?:\n\s{2,}|\n[a-z]|\n---)', content, re.MULTILINE)
if match:
    print(match.group(1).strip()[:120])
else:
    match = re.search(r'^description:\s*(.+)', content, re.MULTILINE)
    if match:
        print(match.group(1).strip()[:120])
    else:
        print('No description')
" 2>/dev/null || echo "No description")

  # Extract tier from README.md if it exists
  tier="Free"
  if [ -f "$readme_md" ]; then
    tier_line=$(grep -i "^## Tier" -A 1 "$readme_md" 2>/dev/null | tail -1 || echo "")
    if echo "$tier_line" | grep -qi "premium"; then
      tier="Premium"
    elif echo "$tier_line" | grep -qi "enterprise"; then
      tier="Enterprise"
    fi
  fi

  # Extract category from README.md
  category="Uncategorized"
  if [ -f "$readme_md" ]; then
    cat_line=$(grep -i "^## Category" -A 1 "$readme_md" 2>/dev/null | tail -1 || echo "")
    if [ -n "$cat_line" ]; then
      category="$cat_line"
    fi
  fi

  CATALOG="$CATALOG| [$skill_name](skills/$skill_name/) | $category | $tier | $description |\n"
done

# Replace catalog section in README
if [ -n "$CATALOG" ]; then
  python3 -c "
import re
readme = open('$README').read()
table_header = '| Skill | Category | Tier | Description |\n|-------|----------|------|-------------|'
new_catalog = table_header + '\n' + '''$(echo -e "$CATALOG")'''.rstrip()
pattern = r'(<!-- CATALOG:START.*?-->\n).*?(\n<!-- CATALOG:END)'
replacement = r'\1' + new_catalog + r'\2'
updated = re.sub(pattern, replacement, readme, flags=re.DOTALL)
open('$README', 'w').write(updated)
print('Catalog updated with $(echo -e "$CATALOG" | grep -c "|") skills')
"
fi
