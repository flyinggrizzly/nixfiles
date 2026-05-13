---
name: evaluate-pr-comments
description: |
  Triage PR review comments on the current branch, propose fixes per comment,
  get user approval, and commit each accepted fix as a discrete commit. With
  `--submit`, push and reply via the `pr-comment` skill. Trigger phrases:
  "address the PR comments", "evaluate the review feedback", "respond to the
  review".
---

# evaluate-pr-comments

## Reply tone

Replies generated for `--submit` follow `pr-comment`'s Tone rules. State what changed, link commit SHA, no preamble.

## Input

`$ARGUMENTS` may contain:

- `--submit` — push commits and post replies after applying
- `--no-bots` — exclude bot comments (default: include all, incl. bots)
- extra context (reviewer name, thread, file) to narrow scope

## Procedure

### Step 1: Detect stack tool

`STACK_TOOL=gt` if `gt branch info` succeeds in the current repo, else `git`.

### Step 2: Identify the PR

```bash
gh pr view --json number,url,headRefName,baseRefName,author
```

If no PR exists for the current branch, stop and tell the user.

### Step 3: Pull review comments

Inline review comments:

```bash
gh api "repos/<owner>/<repo>/pulls/<number>/comments" --paginate \
  --jq '.[] | {id, in_reply_to_id, path, line, body, user: .user.login, user_type: .user.type, html_url, commit_id}'
```

Top-level issue comments:

```bash
gh api "repos/<owner>/<repo>/issues/<number>/comments" --paginate \
  --jq '.[] | {id, body, user: .user.login, user_type: .user.type, html_url}'
```

If `--no-bots` passed, drop entries where `user_type == "Bot"` before grouping.

Group inline comments into threads via `in_reply_to_id`. If `$ARGUMENTS`
narrows scope, filter accordingly.

### Step 4: Evaluate and group

For each thread, read the cited file at the cited line, check if the issue
still holds in the working tree, then classify:

- **actionable** — clear, correct, needs code change
- **question** — needs reply, no code change
- **noise** — incorrect, stale, or already addressed
- **defer** — valid but out of scope

If multiple threads target the same code or describe the same issue, merge
them into one proposed change and note which threads it satisfies.

### Step 5: Walk the user through each item

Per item, show:

```
[N/M] <reviewer> on <file>:<line>
  Comment:    <summary>  (<html_url>)
  Verdict:    actionable | question | noise | defer
  Reasoning:  <one or two sentences>
  Proposed:   <change description or reply text>
```

For actionable items, also show the proposed diff.

Ask per item: **apply / skip / revise / reply-only**.

- apply — commit it
- skip — leave alone
- revise — regenerate proposal, ask again
- reply-only — queue reply for `--submit`, no code change

### Step 6: Commit each approved change

One commit per accepted change/group. Do not bundle unrelated fixes.

- `STACK_TOOL=gt`: `gt modify -c -m "<msg>"`. If the comment targets a
  downstack branch, `gt checkout <branch>` first, commit, then return.
- `STACK_TOOL=git`: `git add -- <paths> && git commit -m "<msg>"`

Commit message:

```
<scope>: address <reviewer> feedback on <file>

Refs: <html_url>
```

### Step 7: If `--submit`

Push:

- `STACK_TOOL=gt`: `gt submit` (or `gt submit --stack` if multiple branches
  were touched)
- `STACK_TOOL=git`: `git push` (no `--force` without explicit user approval)

Then, for each applied or reply-only item, invoke the `pr-comment` skill once
per thread with the reply body and the thread's `comment_id`. The reply body
should acknowledge the feedback and summarize what changed (link the fix
commit SHA where relevant). `pr-comment` handles the attribution banner and
approval gate.

### Step 8: Final summary

Report:

- Counts: applied / skipped / replied / deferred
- New commit SHAs and the branch each is on
- Push and reply status (if `--submit`)
- Threads left unaddressed for manual follow-up

## Hard rules

- Never resolve threads on GitHub — that's the author's job.
- Never `git push --force` without explicit user approval.
- For Graphite stacks, downstack comments get fixed on the downstack branch,
  not as a fixup on the current branch.
