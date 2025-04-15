## Prerequisites
- **Target Code:** $ARGUMENTS
- **Environment:** Assume execution occurs within a local clone of the relevant Git repository with access to the `git` command-line tool.

## Objective
Resolve rebase and merge conflicts. Respect the intent of the local branch and upstream, integrating both into the resolution.

## Methodology
1. Resolve the conflicts
2. Test the changes
  - use an iterative approach
  - run all tests that cover the changed code
  - if any tests fail, review your conflict resolution for bugs
  - make any changes to the conflicted code necessary so that the tests pass

## Execution constraint
- Use a bash login shell to run tests (like `bash -l <test_command>`)
- DO NOT STAGE ANY CHANGES IN GIT
- DO NOT MAKE ANY GIT COMMITS
