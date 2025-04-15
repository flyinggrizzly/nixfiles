## Prerequisites
- **Target Code:** $ARGUMENTS, use `HEAD` as the starting revision.
- **Environment:** Assume execution occurs within a local clone of the relevant Git repository with access to the `git` command-line tool.

## Objective
Trace the specified code snippet back through the Git history to identify the commit where it was originally introduced.

## Methodology
1.  **Tool:** Primarily utilize `git blame`.
2.  **Process:** Employ an iterative approach. Start the trace from the specified file and lines in the starting revision.
3.  **Backward Iteration:** For each relevant line (or the block's representative line), use `git blame` to find the commit (`COMMIT`) that last modified it. Then, examine the state of the
 file in the parent commit (`COMMIT^`).
4.  **Trace Logic:** Repeat the `blame` operation on `COMMIT^` (adjusting line numbers if necessary due to changes in that parent commit) to find the *previous* commit that modified the li
ne(s). Continue this process backward through the commit history.
5.  **Origin Identification:** The process stops when a commit is found where the lines were *added* rather than modified, or when the blame trace can go no further back for those specific
 lines. This identifies the origin.

## Refactoring Handling
- The trace must robustly follow the code snippet even if it was moved between files, renamed, or significantly refactored.
- Utilize `git blame` features designed for detecting code movement and copying (e.g., the `-C` option, potentially multiple times for broader detection) as needed during the trace.

## Output Requirements
- Provide a concise, chronologically ordered list (oldest relevant commit first, leading up to the commit identified in the starting revision) of the key commits in the code's lineage.
- **Include:** Only commits where the target snippet was **introduced**, **significantly modified**, or **moved/renamed**.
- **Format:** For each commit listed, provide a link to the commit on github, and a brief summary (e.g., the first line of the commit message).

## Execution Constraint
- Use `git --no-pager ...` to avoid pagers being used
