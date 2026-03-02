---
name: mega-refactor
description: >
  Plan and execute large-scale codebase refactors that span too many files for a single pass.
  Use this skill when the user asks to refactor, rename, restructure, or migrate patterns across
  a codebase — especially when the change touches 5+ files or involves cross-cutting concerns.
  Triggers on: "refactor this codebase", "large refactor", "mega refactor", "big refactor",
  "refactor across files", "rename across the codebase", "migrate this pattern",
  "this refactor is too big", "refactor the whole module", "restructure this project",
  "move these files and update all imports", "change this interface everywhere",
  "refactor plan", "break this refactor into steps", "rename this class everywhere",
  "update all usages of", "migrate from X to Y across the project", or any refactoring request
  that involves multiple files, modules, or cross-file dependencies — even if the user doesn't
  realize it's a large refactor. Also trigger when a straightforward-sounding refactor
  (like "rename UserService to AuthService") actually affects many files across the codebase.
---

# Mega-Refactor

Execute large-scale codebase refactors safely by breaking them into a dependency-ordered plan,
executing chunk-by-chunk, and verifying integrity after every step.

## Why This Skill Exists

Large refactors fail when attempted in one pass because:
- Context windows can't hold the entire affected codebase at once
- Changes in file A create cascading updates needed in files B, C, D
- A single mistake mid-refactor leaves the codebase in a broken intermediate state
- Without a plan, it's easy to miss references and leave dangling imports

This skill solves all of these by treating refactoring as a graph problem.

## Core Workflow

### Phase 1: Scope & Analyze

1. **Understand the goal.** Ask the user (or infer from context):
   - What is being refactored? (rename, restructure, pattern migration, API change, etc.)
   - What is the target scope? (specific directory, module, or entire project)
   - Are there tests? What command runs them?

2. **Map the blast radius.** Use Grep and Glob to find every file affected:
   - Search for the exact symbol/pattern being changed (e.g., `UserService`)
   - Also search for derived names: camelCase variants (`userService`), file names
     (`UserService.ts`), kebab-case (`user-service`), and SCREAMING_SNAKE (`USER_SERVICE`)
   - Search for imports, type references, string literals (including in JSON configs,
     log messages, error strings, and API responses), and hardcoded path strings
   - Search test files separately — they often reference symbols in describe blocks,
     mock setups, and assertion values
   - Check for file names that match the old symbol and need renaming
   - Build a list of every file that needs modification

3. **Detect dependencies between changes.** Identify ordering constraints:
   - Interface/type definitions must change before implementations
   - Exported symbols must change before importers
   - File renames must happen in the same chunk as export/import path updates
   - Config/env changes must happen before code that reads them
   - Database schema changes must happen before ORM code
   - Test fixtures must update alongside the code they test

### Phase 2: Plan

4. **Create the refactoring plan as an ordered chunk list.** Group related changes into chunks where:
   - Each chunk is small enough to execute in one pass (target: 3-8 files per chunk)
   - Each chunk leaves the codebase in a valid state (tests should pass after each chunk)
   - Chunks are ordered by dependency (upstream changes first)
   - Each chunk has a clear description of what it does

   Output the plan in this format:
   ```
   ## Refactoring Plan: [Goal]

   Blast radius: X files across Y directories
   Estimated chunks: N
   Test command: [command]

   ### Chunk 1: [Description]
   Files: [list]
   Changes: [what happens]
   Depends on: — (none, this is the root)

   ### Chunk 2: [Description]
   Files: [list]
   Changes: [what happens]
   Depends on: Chunk 1

   ...
   ```

5. **Present the plan for approval.** Show the user the full plan before executing.
   Wait for explicit approval. If the user wants changes, revise the plan.

### Phase 3: Execute

6. **Execute chunks in order.** For each chunk:

   a. **Pre-check**: Run the test suite. If tests are already failing, stop and report.
      Do not start a chunk on a broken codebase.

   b. **Execute the changes**: Make all modifications for this chunk.
      - Use Edit tool for surgical changes (preferred — shows diffs)
      - For renames: rename files first (via Bash `mv`), then update all import paths
      - Use Grep to find every reference before modifying — search all case variants
        (PascalCase, camelCase, kebab-case) and string literals, not just imports
      - After editing, search again to confirm no references were missed

   c. **Verify**: Run the test suite again.
      - If tests pass: commit with message `refactor: [chunk description]` and proceed
      - If tests fail: diagnose and fix within this chunk before moving on
      - If fix requires touching files outside this chunk's scope: stop, report the
        dependency issue, and ask whether to revise the plan

   d. **Reference integrity check**: After each chunk, run a targeted search for:
      - The OLD symbol/pattern name (should return zero results, or only in expected places like changelogs)
      - Any import errors or unresolved references introduced by this chunk
      - Type errors if the project uses TypeScript/Python type checking

7. **After all chunks complete**, run a final verification:
   - Full test suite pass
   - Search for any remaining old references
   - Check for unused imports introduced during the refactor
   - Summarize what was changed: files modified, lines changed, chunks completed

### Phase 4: Report

8. **Output a refactoring summary:**
   ```
   ## Refactoring Complete: [Goal]

   Chunks executed: N/N
   Files modified: X
   Tests: all passing
   Commits: [list of commit hashes with descriptions]

   ### Remaining items (if any)
   - [anything that couldn't be automated — manual review needed]
   ```

## Handling Failures

### Tests fail after a chunk
- Diagnose the failure (read the test output carefully)
- If it's a missed reference: fix it within the current chunk, re-run tests
- If it reveals a plan flaw: pause, explain the issue, suggest plan revision
- Never push forward with failing tests

### Unexpected scope expansion
If a chunk reveals more affected files than planned:
- Stop after completing the current chunk
- Report the discovery: "Found N additional files affected by [reason]"
- Add new chunks to the plan and get approval before continuing

### User wants to abort mid-refactor
- Each chunk is an atomic commit, so the codebase is in a valid state after any chunk
- Report which chunks completed and which remain
- The user can `git revert` individual chunks if needed

## Examples

### Example 1: Rename a service class across a Node.js project

**User says:** "Rename UserService to AuthenticationService everywhere"

**What happens:**
1. Grep for `UserService` AND `userService` across the project → finds 23 files
2. Also find: `UserService.ts` file needs renaming, `"UserService"` string in config JSON,
   camelCase `userService` variable instances in controllers and middleware
3. Plan: 4 chunks (rename file + update definition, internal consumers, controllers + middleware, tests + config)
4. Execute chunk-by-chunk with test verification after each
5. Final search for `UserService`, `userService`, old file path confirms zero remaining references

### Example 2: Migrate from REST to GraphQL pattern

**User says:** "Migrate the user module from REST controllers to GraphQL resolvers"

**What happens:**
1. Map all REST endpoints in the user module
2. Identify shared services, validators, middleware that need adapting
3. Plan: create GraphQL schema → create resolvers → update services → update tests → remove old controllers
4. Each chunk adds the new pattern before removing the old one (no broken intermediate states)

### Example 3: Extract a shared library from a monolith

**User says:** "Extract the payment processing code into a shared package"

**What happens:**
1. Trace all payment-related code and its dependencies
2. Identify what can move vs. what must stay (coupling analysis)
3. Plan: create package structure → move pure utilities → move core logic → update imports → add package boundary tests
4. Execute with particular attention to circular dependency prevention

## Important Principles

- **Never edit a file you haven't read first.** Always Read before Edit.
- **Search twice.** After making changes, search again to confirm nothing was missed.
- **Atomic commits.** Each chunk gets its own commit. Never batch multiple chunks.
- **Tests are the source of truth.** If tests fail, the refactor is wrong — not the tests
  (unless the tests themselves need updating as part of the refactor, which should be
  explicitly called out in the plan).
- **Preserve behavior.** Refactoring changes structure, not behavior. If the user wants
  behavior changes, those should be separate commits after the refactor.
- **Communicate progress.** After each chunk, briefly report: "Chunk 3/6 complete: [description]. Tests passing."
