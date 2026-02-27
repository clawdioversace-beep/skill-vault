# Mega-Refactor

Refactor codebases too large for one context window — planned as a dependency graph, executed chunk-by-chunk, verified after every step.

## What It Does

Turns scary cross-codebase refactors into safe, systematic operations. Analyzes the blast radius, creates a dependency-ordered plan, executes in atomic chunks with test verification after each step, and confirms no dangling references remain. Handles file renames, all case variants (PascalCase, camelCase, kebab-case), string literals in configs, and cross-file consistency.

## Examples

```
User: "Rename UserService to AuthenticationService everywhere"
→ Maps 23 files, plans 4 chunks, executes with atomic commits,
  verifies zero remaining references

User: "Extract the payment module into a shared package"
→ Traces dependencies, plans extraction order, moves code with
  import updates, verifies no circular deps
```

## Install

```bash
cp -r skills/mega-refactor ~/.claude/skills/
```

## Category

Developer Tools

## Tier

Premium
