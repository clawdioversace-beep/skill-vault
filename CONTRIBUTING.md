# Contributing to Skill Vault

Thanks for contributing! Here's how to get a skill into the vault.

## Before You Build

1. **Check existing skills** — browse `skills/` to avoid duplicates
2. **Validate demand** — is someone actually asking for this? Check Reddit, GitHub issues, X
3. **Test feasibility** — can Claude actually do the hard part? Try it manually first

## Skill Requirements

Every skill must include:

| File | Required | Purpose |
|------|----------|---------|
| `SKILL.md` | Yes | Skill instructions with YAML frontmatter |
| `evals/evals.json` | Yes | 3+ test cases with expectations |
| `README.md` | Yes | Human-readable description |
| `scripts/` | No | Executable code for deterministic tasks |
| `references/` | No | Supplementary docs loaded on-demand |

### SKILL.md Quality Checklist

- [ ] YAML frontmatter with `name` and `description`
- [ ] Description includes 5+ trigger phrases
- [ ] Under 500 lines
- [ ] 2-3 examples with input/output
- [ ] Error handling guidance
- [ ] No hardcoded paths
- [ ] Works across environments (macOS, Linux, Windows where applicable)

### Evals Quality Checklist

- [ ] Minimum 3 test cases
- [ ] Realistic prompts (what a real user would type)
- [ ] Clear, checkable expectations
- [ ] At least one edge case
- [ ] At least one happy path

## Submitting

1. Fork the repo
2. Create a branch: `skill/your-skill-name`
3. Add your skill directory under `skills/`
4. Run the validation script: `bash scripts/validate-skill.sh skills/your-skill-name`
5. Open a PR with title: `Add skill: your-skill-name`

## PR Template

Your PR description should include:

```
## Skill: [name]

**Pitch:** [one-liner]
**Category:** [Developer Tools / Productivity / Content / Data / etc.]
**Tier:** [Free / Premium / Enterprise]
**Evals:** [X/X passing]

### Demand Signal
[Where did you find evidence people want this?]

### What Exists Today
[What alternatives exist and why this is different]
```

## Review Process

1. **Automated checks** — CI validates structure, format, and eval schema
2. **Quality review** — a maintainer reads the SKILL.md and checks trigger quality
3. **Merge** — skill gets added to the catalog automatically

Typical review time: 1-3 days.

## Updating Existing Skills

Found a bug or improvement for an existing skill? Same process — fork, branch, PR. Include what changed and why in the PR description.

## Code of Conduct

Be helpful. Ship quality. Don't submit junk to pad numbers. One good skill beats ten mediocre ones.
