Access the most recent CI run for #ARGUMENT and iteratively resolve the issues using your PROCEDURE.

<PROCEDURE>
  1. Access the CI run
  2. Run `gt sync && dev up` to ensure our code is up to date.
      - **IMPORTANT: IF THE BRANCH CANNOT BE CLEANLY RESTACKED, ABORT IMMEDIATELY AND ASK ME FOR HELP.**
  3. Review the failures, and understand the root causes. Ultrathink.
  4. For any failures **caused by this branch**, append commits to fix them.
  5. For any failures **not caused by this branch**, do nothing.
  6. When you have fixed all issues, run `gt submit` to push your changes.
      - If this branch is a draft pull request, manually trigger CI with `devx ci trigger --force`
  7. Monitor CI for success or failure.
  8. If CI succeeds, you are done, thank you.
  9. If CI fails, repeat this procedure again for the latest CI results.
</PROCEDURE>

