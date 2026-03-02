# Changelog & Release Notes — Claude Code Skill

**One set of changes. Four audience-ready outputs.**

Every release needs a changelog. But your developers, users, and executives all need different versions. Writing three separate documents from the same git history is tedious busywork.

This skill reads your git log and generates all four formats automatically:

1. **Developer Changelog** — Technical, Keep a Changelog format, every commit categorized
2. **User-Facing Release Notes** — Plain language, no jargon, focused on what changed for them
3. **Executive Summary** — 3-5 bullet points with business impact and risk assessment
4. **PR Summary** — File counts, testing notes, ready to paste

---

## What You Get

- **SKILL.md** — Drop-in Claude Code skill (214 lines)
- **Evals** — 5 test scenarios covering releases, PRs, stakeholder updates, and edge cases
- **This guide** — Install instructions and usage examples

## How It Works

Tell Claude what range to cover — a version tag, a PR branch, "last 2 weeks", or "since v1.3.0". The skill:

1. Reads git log + diff stats for the range
2. Categorizes every commit (features, fixes, breaking changes, refactors, etc.)
3. Generates the formats you ask for (or all of them if you just say "release notes")
4. Outputs ready-to-paste documentation

Handles conventional commits and freeform messages. Works in monorepos with path scoping.

---

## Use Cases

```
> Write release notes for v2.0
> Summarize this PR for the description
> What did we ship this sprint? Give me a stakeholder update.
> Generate changelog for the last 3 commits
> Full release package — developer, user, and executive versions
```

---

## Install (30 seconds)

```bash
unzip changelog-release-notes.zip -d changelog-skill
cp -r changelog-skill/changelog-release-notes ~/.claude/skills/
```

Auto-triggers on "changelog", "release notes", "summarize changes", "what shipped", and more.

---

## Requirements

- [Claude Code](https://claude.ai/code) (Anthropic's CLI tool)
- A git repository with commit history

## Support

Issues? [skill-vault](https://github.com/clawdio/skill-vault) on GitHub or [@clawdio](https://x.com/clawdio) on X.

---

Built by [@clawdio](https://x.com/clawdio) — shipping AI tools that work.
