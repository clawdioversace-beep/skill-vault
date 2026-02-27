# Skill Vault

**Curated, tested Claude skills that actually work.**

Every skill in this repo has evals, a quality-checked SKILL.md, and has been verified to trigger correctly. No junk, no placeholders, no "coming soon."

## Skills

<!-- CATALOG:START - Auto-generated, do not edit -->
| Skill | Category | Tier | Description |
|-------|----------|------|-------------|
| [mega-refactor](skills/mega-refactor/) | Developer Tools | Premium | Plan and execute large-scale codebase refactors that span too many files for a single pass. |
| [prompt-to-skill](skills/prompt-to-skill/) | Meta / Productivity | Free | Turn any prompt, workflow, or set of instructions into a persistent Claude skill with a slash command. |
<!-- CATALOG:END -->

## Install a Skill

### One skill
```bash
# Copy into your Claude skills directory
cp -r skills/mega-refactor ~/.claude/skills/
```

### All skills
```bash
# Clone and symlink
git clone https://github.com/clawdioversace/skill-vault.git
ln -s $(pwd)/skill-vault/skills/* ~/.claude/skills/
```

### From Claude Code
Tell Claude: "Install the mega-refactor skill from skill-vault" — if it has filesystem access, it can clone and copy.

## What Makes This Different

There are 22,000+ skills on SkillHub. Most are untested one-liners.

Every skill here meets a quality bar:

- **Tested** — 3+ evals with clear expectations, all passing
- **Pushy triggers** — descriptions aggressively list trigger phrases so Claude actually uses the skill (undertriggering is the #1 failure mode)
- **Under 500 lines** — lean SKILL.md with progressive disclosure
- **Real demand** — built from validated demand signals, not "wouldn't it be cool if"

## Contributing

We accept skills from humans and agents. See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

**Quick version:**
1. Fork this repo
2. Create `skills/your-skill-name/SKILL.md` following the template
3. Add `skills/your-skill-name/evals/evals.json` with 3+ test cases
4. Open a PR — our CI validates format, runs eval checks, and labels it for review

**Agents contributing autonomously:** Read the [CLAUDE.md](CLAUDE.md) in this repo for the machine-readable protocol.

## Quality Tiers

| Tier | Price | Purpose |
|------|-------|---------|
| Free | $0 | Brand builders — solves common pain, open source |
| Premium | $5-50 | Complex workflows, significant time savings |
| Enterprise | Custom | Bespoke skills for teams |

Free skills are fully open. Premium skills include the SKILL.md (so you can see what it does) but the full package with scripts/references may require purchase.

## Repo Structure

```
skill-vault/
├── skills/                    # All skills live here
│   ├── mega-refactor/
│   │   ├── SKILL.md           # The skill instructions
│   │   ├── evals/
│   │   │   └── evals.json     # Test cases
│   │   └── README.md          # Human-readable description
│   └── prompt-to-skill/
│       ├── SKILL.md
│       ├── evals/
│       │   └── evals.json
│       └── README.md
├── templates/                 # Skill templates for contributors
│   └── skill-template/
├── scripts/                   # Validation and automation
├── CLAUDE.md                  # Agent contribution protocol
├── CONTRIBUTING.md            # Human contribution guide
└── README.md                  # You are here
```

## License

MIT — use these skills however you want. Attribution appreciated but not required.
