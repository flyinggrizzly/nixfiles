---
name: pr-comment
description: |
  Post a comment or review reply on the current branch's PR, prefixed with a
  Pi attribution banner. Trigger phrases: "post this", "post that to the PR",
  "reply to the reviewer", "send this as a PR comment", "respond on the PR".
---

# pr-comment

Post a comment to the PR for the current branch with a Pi attribution banner.

## Input

`$ARGUMENTS` may contain the comment body. If empty, identify the comment from
recent conversation history.

Flags (strip before treating remainder as body):

- `--yolo` — skip the Step 4 approval gate and post immediately after Step 3.

## Procedure

### Step 1: Identify the comment

In order of preference:

1. Use the literal text in `$ARGUMENTS` if provided.
2. Use the most recent draft you and the user discussed in this session.
3. If neither is unambiguous, ask the user which message to post and wait.

### Step 2: Identify the target

Determine where the comment goes:

- **Top-level PR comment** (default): general response to the PR.
- **Reply to a specific review comment**: if the conversation references a
  reviewer thread or inline comment, reply to that thread.

Resolve the PR number from the current branch:

```bash
gh pr view --json number,url --jq '{number, url}'
```

If no PR exists for the current branch, stop and tell the user.

### Step 3: Build the final body

Prefix the body with this banner exactly:

```markdown
> [!INFO]
> Posted on behalf of flyinggrizzly by Pi/<model_name>
```

For `<model_name>`, use your active model name (e.g., `Claude Sonnet 4`,
`GPT-5`). If unknown, fall back to `Pi`.

Then a blank line, then the comment body.

### Step 4: Show the user before posting

Display the full final body (banner + content) and the target (top-level vs.
reply-to thread) and wait for explicit approval. Do not post until the user
confirms.

If `--yolo` was passed, skip the approval wait — still display the body and
target, then proceed straight to Step 5.

### Step 5: Post

Use `gh` to post:

- **Top-level comment**:
  ```bash
  gh pr comment <number> --body-file <tmpfile>
  ```
- **Reply to a review comment thread**: use the GitHub API so the reply
  threads correctly. Read the body from file via `@<path>` to preserve
  markdown, code fences, and special characters:
  ```bash
  gh api -X POST \
    "repos/<owner>/<repo>/pulls/<number>/comments/<comment_id>/replies" \
    -F body=@<tmpfile>
  ```

Never inline the body as `--body "..."` or `-f body="$(cat ...)"` — both
break on quotes, backticks, and `>` markdown.

### Step 6: Confirm

Show the URL of the posted comment so the user can verify.
