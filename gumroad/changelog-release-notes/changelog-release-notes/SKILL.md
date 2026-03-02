---
name: changelog-release-notes
description: >
  Generate changelogs, release notes, and summaries from git history — tailored to different
  audiences from the same set of changes. Use this skill when the user says "generate changelog",
  "write changelog", "update changelog", "release notes", "write release notes",
  "draft release notes", "what changed since last release", "summarize recent changes",
  "PR summary", "summarize this PR", "what's in this PR", "prepare a release",
  "ship notes", "version bump notes", "executive summary of changes", "stakeholder update",
  "what did we ship", "write up the release", or any request to summarize git history for
  documentation, communication, or release management — even if they just say "changelog"
  without specifying an audience.
---

# Changelog & Release Notes

Generate audience-aware documentation from git history. One set of changes, multiple outputs
tailored to who's reading: developers, users, or executives.

## Why Multiple Audiences Matter

The same set of changes means different things to different people:
- **Developers** want the technical details: what files changed, what APIs broke, what was refactored
- **Users** want to know what's new, what's fixed, and what might break their workflow
- **Executives** want 3 bullet points: what shipped, what's the impact, any risks

A single changelog format forces one audience to wade through irrelevant detail or miss
important context. This skill generates the right format for each audience automatically.

## Output Formats

### 1. Developer Changelog (CHANGELOG.md)

Technical, comprehensive, grouped by type. Follows Keep a Changelog conventions.

```markdown
## [1.4.0] - 2026-02-27

### Added
- WebSocket support for real-time notifications (#234)
- Rate limiting middleware with configurable thresholds (#241)

### Changed
- Migrated auth module from passport to custom JWT handler (#238)
- Updated Node.js minimum version to 20.x

### Fixed
- Memory leak in connection pool during high concurrency (#229)
- Incorrect timezone handling in scheduled jobs (#235)

### Removed
- Deprecated v1 API endpoints (#240)
```

### 2. User-Facing Release Notes

Plain language, focused on what users care about. No internal jargon.

```markdown
# What's New in v1.4.0

**Real-time notifications** — You'll now see updates instantly without refreshing.

**Faster performance** — We fixed a memory issue that could slow things down during
peak usage.

**Scheduled tasks are now timezone-aware** — If your scheduled jobs were running at
the wrong time, that's fixed.

**Heads up:** The old v1 API has been removed. If you're still using v1 endpoints,
migrate to v2 before upgrading.
```

### 3. Executive Summary

3-5 bullet points. Impact-focused. No technical detail.

```markdown
## Release Summary: v1.4.0

- **Real-time capabilities added** — enables instant notification features customers have requested
- **Performance improvement** — resolved bottleneck affecting high-traffic periods
- **Legacy API removed** — completes the v1→v2 migration (6 months ahead of schedule)
- **Risk: none** — all changes backward-compatible except planned v1 deprecation
```

### 4. PR Summary

Concise description of a branch's changes for pull request descriptions.

```markdown
## Summary

Adds WebSocket support for real-time notifications and removes deprecated v1 API endpoints.

## Changes
- Implement WebSocket server with auto-reconnect (3 files, +450/-20 lines)
- Add rate limiting middleware (2 files, +180 lines)
- Remove v1 API routes and controllers (8 files, -1,200 lines)
- Update integration tests for v2-only environment

## Testing
- Added 12 new tests for WebSocket lifecycle
- All existing tests pass
- Load tested at 10k concurrent connections
```

## Workflow

### Step 1: Determine the scope

Figure out what git range to cover:

1. If the user specifies a range → use it (e.g., "since v1.3.0", "last 2 weeks", "this PR")
2. If not specified → find the last tag and use `[last-tag]..HEAD`
3. If no tags exist → use the last 20 commits or ask the user
4. For PR summaries → use `main..HEAD` or the PR's base..head

Run `git log` with the determined range. Use `--pretty=format:"%h %s (%an, %ai)"` to get
hash, subject, author, and date. Also run `git diff --stat` for the same range to get
file change counts.

### Step 2: Analyze and categorize

Read through the commits and categorize each one:

| Category | Signals | Show in Dev | Show in User | Show in Exec |
|----------|---------|-------------|--------------|--------------|
| Feature | `feat:`, `add`, new functionality | Yes | Yes | Yes |
| Fix | `fix:`, `bug`, `patch`, `resolve` | Yes | Yes (if user-facing) | Only if critical |
| Breaking | `BREAKING`, `!:`, removes API | Yes (highlighted) | Yes (warning) | Yes (risk) |
| Performance | `perf:`, `optimize`, `speed` | Yes | Yes (if noticeable) | Only if significant |
| Security | `security`, `vuln`, `CVE` | Yes | Yes | Yes |
| Refactor | `refactor:`, `restructure`, `clean` | Yes | No | No |
| Docs | `docs:`, `readme`, `comment` | Yes | No | No |
| Tests | `test:`, `spec`, `coverage` | Yes | No | No |
| CI/CD | `ci:`, `build:`, `deploy`, `pipeline` | Yes | No | No |
| Chore | `chore:`, `bump`, `deps`, merge commits | Yes (brief) | No | No |

**For freeform commits** (not using conventional commit format): read the commit message
content and infer the category. When ambiguous, include in the developer changelog but
exclude from user-facing outputs.

### Step 3: Generate requested outputs

Ask the user which formats they want, or generate all if they say "release notes" generically.

**For each format, follow these rules:**

**Developer Changelog:**
- Group by category using Keep a Changelog headings (Added, Changed, Fixed, Removed, etc.)
- Include PR/issue numbers if present in commit messages
- Include the version number if the user provides one
- List every meaningful commit (skip only merge commits and version bumps)

**User-Facing Release Notes:**
- Lead with features and user-visible improvements
- Translate technical terms to plain language
- Group fixes as "Bug Fixes" only if they affected user experience
- Call out breaking changes prominently with migration guidance
- Skip refactors, test changes, CI changes, and internal tooling
- Tone: friendly, professional, second person ("you'll see...")

**Executive Summary:**
- Maximum 5 bullet points
- Each bullet: what changed + why it matters (business impact)
- Include a risk assessment line (Risk: none / low / medium / high)
- Skip anything that doesn't have visible business impact
- Tone: crisp, results-focused

**PR Summary:**
- Start with a 1-2 sentence summary of the PR's purpose
- List specific changes with file counts
- Include testing notes
- Keep it factual — no marketing language

### Step 4: Output

Present each generated format clearly separated. If the user wants them written to files:
- Developer changelog → append to or create `CHANGELOG.md`
- Release notes → write to `RELEASE_NOTES.md` or output for pasting
- Executive summary → output directly (usually for email/Slack)
- PR summary → output for pasting into PR description

## Handling Edge Cases

### Very few commits (< 5)
Still generate all formats but keep them proportionally brief. Don't pad sparse changes
with filler text.

### Very many commits (> 100)
Group more aggressively. For user-facing and executive formats, focus on the top 10-15
most impactful changes. For developer changelog, include everything but group sub-items.

### Mixed conventional and freeform commits
Categorize conventional commits by prefix, infer categories for freeform ones.
Note in the developer changelog: "Note: some commits use freeform messages; categories
are inferred."

### No meaningful changes for an audience
If all commits are internal (refactors, CI, tests), the user-facing and executive
outputs should say: "This release contains internal improvements. No user-facing changes."

### Monorepo with multiple packages
If the user specifies a package/directory scope, filter commits by path:
`git log -- path/to/package`. Note the scope in each output header.

## Important Principles

- **Don't invent changes.** Every line must trace back to an actual commit.
- **Don't editorialize in dev changelogs.** Keep them factual and scannable.
- **Do editorialize in user notes.** Explain WHY a change matters to the user.
- **Breaking changes are always visible** in every format — never hide them.
- **When in doubt, include.** It's easier to trim than to discover missed items later.
