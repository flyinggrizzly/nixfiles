---
name: git-conflict
description: Resolve git/graphite merge & rebase conflicts and prevent recurrence. Trigger manually via `/skill:git-conflict` when conflicts present in working tree, mid-rebase, mid-merge, or when planning a sync that risks conflict. Auto-resolves trivial classes (whitespace, import order, lockfiles, generated files) and pauses for semantic conflicts.
---

# git-conflict

## When to use

- conflict markers (`<<<<<<<`) in working tree
- `gt sync` | `gt restack` | `git rebase` | `git merge` paused on conflict
- planning rebase on stale base & want prevention strategy

## Detect

```
gt status 2>/dev/null || git status
git diff --name-only --diff-filter=U
```

if no conflicts & user asks prevention: skip to **Prevent**.

## Resolve flow

1. list conflicted files
2. classify each file (table below)
3. auto-resolve trivial → stage
4. for semantic: show hunks side-by-side & propose resolution → wait for user
5. after all resolved:
   - rebase: `git rebase --continue` | `gt continue`
   - merge: `git merge --continue`
6. report: files resolved, classification per file, any skipped

## Classification

| Class | Examples | Action |
|---|---|---|
| trivial-lockfile | `package-lock.json` `yarn.lock` `Gemfile.lock` `Cargo.lock` `pnpm-lock.yaml` `go.sum` | take both sides → regenerate (`npm i` `bundle install` `cargo build` `pnpm i` `go mod tidy`) → stage |
| trivial-generated | files with header `// AUTO-GENERATED` `# DO NOT EDIT` | regenerate via project script if known → else mark semantic |
| trivial-imports | conflict only inside import block (top of file, no logic) | union both sides, dedupe, sort per project convention → stage |
| trivial-whitespace | `git diff --check` clean & only whitespace differs | take incoming (`--theirs` for rebase, `--ours` for merge — note rebase inverts) → stage |
| semantic | anything else | propose & wait |

if class uncertain: treat as semantic.

## Rebase ours/theirs gotcha

mid-rebase: `--ours` = upstream, `--theirs` = your commit. mid-merge: opposite. always confirm via `git log --oneline HEAD MERGE_HEAD` | `REBASE_HEAD` before applying.

## Prevent

before starting work | before long-lived branch:

- `gt sync` daily on trunk-tracking branches
- keep stacks shallow (≤3 commits per branch on `gt`)
- rebase feature branch on trunk before review request: `gt restack` | `git fetch && git rebase origin/main`
- split large refactors: rename | move first, logic change second — reduces semantic conflict surface
- coordinate with concurrent authors on shared files (check `git log --since=1.week origin/main -- <file>`)

## Hard rules

- never `git checkout --ours/--theirs` on semantic class
- never `git rebase --skip` without explicit user ok
- never force-push (`gt submit --force` | `git push --force-with-lease`) without user ok
- no test runs (out of scope)
- if mid-operation state unclear: `git status` & ask before any destructive command

## Output format

```
conflicts: N files
  trivial-lockfile: a.lock, b.lock  → resolved
  trivial-imports:  src/x.ts        → resolved
  semantic:         src/y.ts        → awaiting decision
```
