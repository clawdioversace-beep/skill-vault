# Prompt-to-Skill — Claude Code Skill

**Turn any prompt into a permanent, auto-triggering Claude skill.**

You keep pasting the same prompt every session. Or you've built a workflow that works perfectly but lives in your clipboard. Prompt-to-Skill makes it permanent — installed globally with a slash command, auto-triggering on natural language.

Give it a prompt (paste it, describe it, or reference your conversation). It generates a proper SKILL.md with aggressive trigger phrases, installs it to `~/.claude/skills/`, wires up a `/command`, and confirms it works.

---

## What You Get

- **SKILL.md** — Drop-in Claude Code skill (169 lines)
- **Evals** — 5 test scenarios covering simple prompts, complex workflows, and edge cases
- **This guide** — Install instructions and usage examples

## How It Works

1. You provide a prompt in any form — paste text, describe a workflow, or say "turn what we just did into a skill"
2. The skill generates a name, writes SKILL.md with 8-12 trigger phrases, creates a slash command
3. Installs globally to `~/.claude/skills/` — works in every session, every project
4. Confirms with a trigger test

---

## Examples

```
> Make this a skill: Before every commit, run the linter, fix issues, then commit
→ Installed: /auto-commit — triggers on "commit this", "clean commit", "lint and commit"

> Turn what we just did into a skill (after debugging memory leaks)
→ Installed: /memory-leak-debug — triggers on "memory leak", "heap analysis", "OOM"

> I keep pasting this 50-line prompt for competitor pricing analysis
→ Installed: /competitor-pricing — triggers on "check prices", "pricing analysis"
```

---

## Install (30 seconds)

```bash
unzip prompt-to-skill.zip -d pts-skill
cp -r pts-skill/prompt-to-skill ~/.claude/skills/
```

Auto-triggers on "make this a skill", "save this prompt", "install this as a command", and more.

---

## Why This Skill Matters

Prompt-to-Skill is the meta-skill — it lets you build your own skills library from the workflows you already use. Every prompt you save is one less thing you paste manually.

## Requirements

- [Claude Code](https://claude.ai/code) (Anthropic's CLI tool)

## Support

Issues? [skill-vault](https://github.com/clawdio/skill-vault) on GitHub or [@clawdio](https://x.com/clawdio) on X.

---

Built by [@clawdio](https://x.com/clawdio) — shipping AI tools that work.
