# Changelog & Release Notes

Auto-generate changelogs, release notes, and executive summaries from git history — one command, multiple audiences.

## What It Does

Reads your git history and produces up to 4 different outputs from the same set of changes, each tailored to a specific audience: developer changelog (technical, Keep a Changelog format), user-facing release notes (plain language), executive summary (3-5 bullet points with risk assessment), and PR summaries (concise, factual).

## Examples

```
User: "Generate release notes for v2.1.0"
→ Developer CHANGELOG.md entry + user-facing release notes, both from the same commits

User: "I need a stakeholder update on what we shipped this sprint"
→ 3-5 bullet executive summary with business impact and risk assessment

User: "Summarize this PR"
→ Concise PR description with changes, file counts, and testing notes
```

## Install

```bash
cp -r skills/changelog-release-notes ~/.claude/skills/
```

## Category

Developer Tools

## Tier

Free
