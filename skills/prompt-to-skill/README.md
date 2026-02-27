# Prompt-to-Skill

Turn any prompt or workflow into a persistent Claude skill with a slash command — zero manual wiring.

## What It Does

Takes a prompt, workflow, or set of instructions and packages it into a proper Claude skill with YAML frontmatter, pushy trigger descriptions, examples, evals, and installs it as a slash command. Handles the entire pipeline from raw prompt to globally available `/command`.

## Examples

```
User: "Turn this into a skill" [pastes a long prompt]
→ Generates SKILL.md, writes evals, creates slash command,
  installs to ~/.claude/skills/

User: "I keep pasting this prompt every time I review PRs"
→ Packages the PR review workflow as /pr-review skill
```

## Install

```bash
cp -r skills/prompt-to-skill ~/.claude/skills/
```

## Category

Meta / Productivity

## Tier

Free
