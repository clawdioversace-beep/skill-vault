# Mega-Refactor — Claude Code Skill

**Refactor codebases too large for one context window.**

Large refactors are scary. Rename a service class and suddenly 23 files need updating across 6 directories. Miss one reference and the build breaks. Attempt it in one pass and Claude runs out of context halfway through.

Mega-Refactor solves this by treating refactoring as a graph problem: map the blast radius, plan dependency-ordered chunks, execute one chunk at a time with test verification, and confirm zero dangling references when done.

---

## What You Get

- **SKILL.md** — Drop-in Claude Code skill (202 lines of battle-tested instructions)
- **Evals** — 5 test scenarios to verify the skill works in your projects
- **This guide** — Install instructions and usage examples

## How It Works

### 1. Scope & Analyze
You describe the refactor. The skill maps every affected file — searching imports, type references, string literals, config files, and all case variants (PascalCase, camelCase, kebab-case, SCREAMING_SNAKE).

### 2. Plan
Changes are grouped into dependency-ordered chunks (3-8 files each). Interface definitions before implementations. Exports before importers. Each chunk leaves the codebase in a valid state.

### 3. Execute
Chunk-by-chunk execution with atomic commits. Tests run after every chunk. If something breaks, it stops immediately — no half-finished refactors.

### 4. Verify
Final sweep: search for any remaining old references, check for unused imports, confirm tests pass. You get a summary of every file modified and every commit created.

---

## Use Cases

| Scenario | What Mega-Refactor Does |
|----------|------------------------|
| Rename `UserService` to `AuthService` across 23 files | Maps all references (imports, types, strings, configs), plans 4 chunks, executes with test verification |
| Extract payment module into shared package | Traces dependencies, plans extraction order, moves code with import updates, prevents circular deps |
| Migrate Express callbacks to async/await | Finds all callback patterns, migrates middleware before routes, updates error handling and tests |
| Consolidate duplicate validation logic | Identifies common patterns, creates shared module, replaces inline code chunk-by-chunk |
| Restructure monorepo directory layout | Plans file moves, updates all import paths, handles re-exports and barrel files |

---

## Install (30 seconds)

```bash
# Unzip the download
unzip mega-refactor.zip -d mega-refactor-skill

# Copy to Claude Code skills directory
cp -r mega-refactor-skill/mega-refactor ~/.claude/skills/

# Verify
ls ~/.claude/skills/mega-refactor/SKILL.md
```

That's it. The skill auto-triggers whenever you ask Claude Code to do a large refactor.

## Usage

Just describe the refactor naturally:

```
> Rename UserService to AuthenticationService everywhere
> Extract the payment module into a shared package
> Migrate all API endpoints from callbacks to async/await
> Move /src/modules/payments/ to /packages/payment-service/
> Clean up the authentication module — it's 15 files across 3 directories
```

The skill activates automatically on any refactoring request that spans multiple files.

---

## Why Not Just Ask Claude to Refactor?

Without this skill, Claude attempts large refactors in one pass. The problems:

- **Context overflow** — Claude loses track of files when the change is too large
- **Missed references** — String literals, config files, and case variants get overlooked
- **No rollback** — If something breaks halfway, you're stuck debugging a half-refactored codebase
- **No verification** — No systematic check that all old references are actually gone

Mega-Refactor fixes all of these with a structured, graph-based approach.

---

## Requirements

- [Claude Code](https://claude.ai/code) (Anthropic's CLI tool)
- A codebase with tests (the skill uses tests as verification checkpoints)

## Support

Issues or questions? Open a GitHub issue at [skill-vault](https://github.com/clawdio/skill-vault) or reach out on X [@clawdio](https://x.com/clawdio).

---

Built by [@clawdio](https://x.com/clawdio) — shipping AI tools that work.
