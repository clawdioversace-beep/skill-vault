---
name: prompt-to-skill
description: >
  Turn any prompt, workflow, or set of instructions into a persistent Claude skill with a slash command.
  Use this skill when the user says "turn this into a skill", "make this a skill", "package this prompt",
  "create a skill from", "save this as a skill", "install this as a command", "make a /command for this",
  "skillify this", "package this workflow", "I want to reuse this", "make this permanent", or any request
  to convert a prompt, workflow, or set of instructions into a reusable, auto-triggering Claude skill.
  Also trigger when the user pastes a large prompt and says "save this" or "install this" — even if they
  don't use the word "skill" explicitly. If someone says "I keep pasting this prompt every time", that's
  a trigger too.
---

# Prompt-to-Skill

Convert a raw prompt or workflow into a fully installed Claude skill with a matching slash command. The user gives you the prompt; you handle everything: SKILL.md generation, pushy trigger description, global installation, and /command wiring.

## What This Skill Does

1. Takes a raw prompt (pasted text, conversation context, or described workflow)
2. Generates a proper SKILL.md with pushy trigger description
3. Installs it to `~/.claude/skills/[name]/SKILL.md` (global — works in every session)
4. Creates a matching `~/.claude/commands/[name].md` (slash command)
5. Confirms installation with a trigger test

## Step 1: Gather Input

Accept the prompt in any form:
- **Direct paste**: User pastes the full prompt text
- **Conversation reference**: "Turn what we just did into a skill"
- **Description**: "Make a skill that does X, Y, Z"

If the input is vague, ask exactly TWO questions max:
1. What should the skill do? (if unclear from context)
2. What should the /command name be? (suggest one if not provided)

Do NOT over-interview. Get the prompt and move.

## Step 2: Generate the Skill Name

Derive a kebab-case name. Rules:
- 2-4 words max (e.g., `api-test`, `git-changelog`, `data-viz`)
- Prefix with a namespace if the user has one (ask only if they've mentioned a prefix before)
- The name becomes both the skill directory and the /command name

## Step 3: Write the SKILL.md

Follow this structure exactly:

```markdown
---
name: [skill-name]
description: >
  [What it does — 1 sentence]. Use this skill when the user says [LIST 8-12 TRIGGER PHRASES],
  or any request to [broader category]. Also trigger when [edge cases] — even if they don't
  explicitly say "[key term]".
---

[Body: Full instructions from the original prompt, reformatted for Claude]
```

### Description Rules (Critical)

The description is the most important part. Claude undertriggers by default — be aggressive:

- List 8-12 specific trigger phrases the user might say
- Include edge cases: "even if they don't say X"
- Include adjacent phrasings: "also trigger when..."
- Keep under 100 words total (it's always in context)

### Body Rules

- Rewrite the prompt in imperative form ("Do X" not "You should do X")
- Add 2-3 realistic examples if the original prompt doesn't have them
- Include error handling: what to do when the approach fails
- Keep under 500 lines
- Use progressive disclosure: if content exceeds 300 lines, split into references/

## Step 4: Write the Slash Command

Create `~/.claude/commands/[name].md` with a concise version of the prompt. This is what fires when the user types `/[name]`.

Rules:
- Keep under 10 lines — this is a trigger, not full instructions (the SKILL.md handles detail)
- Include `$ARGUMENTS` if the skill accepts parameters
- Use absolute paths for any file references (e.g., `~/project/state/`)

## Step 5: Install

1. Check if `~/.claude/skills/[name]/` already exists — if so, warn the user and ask to overwrite or pick a new name
2. Check if `~/.claude/commands/[name].md` already exists — same conflict check
3. Create directory: `~/.claude/skills/[name]/`
4. Write SKILL.md to that directory
5. Write command to `~/.claude/commands/[name].md`
6. Verify both files exist with a quick `ls`

## Step 6: Confirm

Tell the user:
```
Installed: [skill-name]

Skill:   ~/.claude/skills/[name]/SKILL.md
Command: /[name]

Triggers on: [list 3-4 key trigger phrases]
Test it: Type "/[name]" in any Claude session or say "[trigger phrase]"
```

## Examples

### Example 1: Simple Prompt

**Input**: "Make this a skill: Before every commit, run the linter, fix any issues, then stage and commit with a descriptive message"

**Output**:
```
Installed: auto-commit

Skill:   ~/.claude/skills/auto-commit/SKILL.md
Command: /auto-commit

Triggers on: "commit this", "clean commit", "lint and commit", "auto commit"
Test it: Type "/auto-commit" or say "commit this cleanly"
```

### Example 2: Complex Workflow

**Input**: User pastes a 50-line prompt for analyzing competitor pricing

**Output**:
```
Installed: competitor-pricing

Skill:   ~/.claude/skills/competitor-pricing/SKILL.md
Command: /competitor-pricing [urls]

Triggers on: "check competitor prices", "pricing analysis", "compare prices"
Test it: Type "/competitor-pricing https://competitor.com"
```

### Example 3: From Conversation

**Input**: "Turn what we just did into a skill" (after a session of debugging memory leaks)

**Output**:
```
Installed: memory-leak-debug

Skill:   ~/.claude/skills/memory-leak-debug/SKILL.md
Command: /memory-leak-debug

Triggers on: "memory leak", "heap analysis", "debug memory", "OOM"
Test it: Say "I have a memory leak" in any session
```

## Error Handling

- **Conflict**: If a skill with the same name exists, warn the user and ask to overwrite or rename
- **Empty prompt**: If the user says "make this a skill" but there's no clear prompt in context, ask "What prompt or workflow should I package?"
- **Too broad**: If the prompt tries to do too many things, suggest splitting into 2-3 focused skills
- **Missing triggers**: If you can't think of 8 trigger phrases, the skill might be too niche — flag it

## What NOT to Do

- Don't create skills for one-liners Claude already handles well ("fix this typo")
- Don't install to project-level `.claude/skills/` — always go global (`~/.claude/skills/`)
- Don't make the /command file a duplicate of SKILL.md — keep it concise
- Don't skip the trigger description — this is the #1 failure mode of skills
