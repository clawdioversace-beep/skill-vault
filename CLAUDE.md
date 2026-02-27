# Skill Vault — Agent Contribution Protocol

This file tells Claude (or any AI agent) how to contribute skills to this repository.

## What This Repo Is

A curated collection of high-quality Claude skills. Every skill has evals, tested triggers, and meets a quality bar. If you're an agent building skills, this is where you submit them.

## How to Submit a Skill

### 1. Check if the skill already exists

Before building, search the `skills/` directory for overlapping functionality. Read existing SKILL.md descriptions to avoid duplicates.

### 2. Create the skill directory

```
skills/your-skill-name/
├── SKILL.md          # Required — the skill instructions
├── evals/
│   └── evals.json    # Required — 3+ test cases
├── README.md         # Required — human-readable description
├── scripts/          # Optional — executable code
└── references/       # Optional — supplementary docs
```

### 3. SKILL.md Requirements

The SKILL.md must have YAML frontmatter:

```yaml
---
name: your-skill-name
description: >
  What the skill does and when to trigger it. Be PUSHY — list specific
  trigger phrases. Undertriggering is the #1 failure mode.
---
```

Rules:
- Under 500 lines total
- Description must include 5+ specific trigger phrases
- Include 2-3 examples showing input → output
- Must not hardcode paths or environment-specific values
- Must include error handling guidance

### 4. evals/evals.json Format

```json
{
  "skill_name": "your-skill-name",
  "evals": [
    {
      "id": 1,
      "prompt": "Realistic user prompt",
      "expected_output": "What success looks like",
      "files": [],
      "expectations": [
        "Specific checkable outcome 1",
        "Specific checkable outcome 2"
      ]
    }
  ]
}
```

Minimum 3 evals. At least one should test an edge case.

### 5. README.md Format

```markdown
# Skill Name

One-liner pitch.

## What It Does

2-3 sentences explaining the skill.

## Examples

Show 1-2 real usage examples.

## Install

\`\`\`bash
cp -r skills/your-skill-name ~/.claude/skills/
\`\`\`

## Tier

Free / Premium / Enterprise
```

### 6. Submit via Pull Request

- Branch name: `skill/your-skill-name`
- PR title: `Add skill: your-skill-name`
- PR body: Include the one-liner pitch and eval count

## Quality Bar

Your skill will be rejected if:
- SKILL.md is over 500 lines
- Fewer than 3 evals
- Description doesn't include trigger phrases
- It duplicates an existing skill without meaningful differentiation
- No examples in the SKILL.md body
- Hardcoded paths or environment-specific assumptions

## Naming Conventions

- Skill directory name: `kebab-case` (e.g., `mega-refactor`, not `MegaRefactor`)
- SKILL.md `name` field must match the directory name
- Keep names short and descriptive (2-3 words max)

## What NOT to Submit

- Skills that wrap a single API call (too thin)
- Skills that require paid external services without alternatives
- Skills with no clear trigger scenario
- Skills that duplicate Claude's built-in capabilities without adding value
