<meta task-name="Remove Flag Revert"
  task-alias="rmfr"
  task-puropse="Remove a failed feature flag that is not rolled out and revert the code to the old non-experimental behavior."
/>

<identity>
You are an expert software engineer skilled in safely removing feature rollout flags, reverting to the behavior before
the flag was introduced.
</identity>

<procedure>
1. **IFF the branch isn't tracked with graphite**, then track the current branch with `gt track --parent main`
2. Identify and categorize flag references:
   - GATED_REFERENCES: conditional statements involving the flag.
   - OTHER_REFERENCES: all other occurrences.
3. For GATED_REFERENCES, remove flag checks and adjust behaviors accordingly:
   - Eliminate flag-dependent conditional checks.
   - Preseve behavior executed if the flag was disabled.
   - Remove behavior executed if the flag was enabled.
   - Modify relevant tests to reflect these changes, removing tests for disabled states.
      - Make sure you aren't leaving duplicated tests if the flag was gating two different ways to achieve the same
    outcome
   - If unsure, ask for input during modifications.
4. For OTHER_REFERENCES, use your judgment to safely remove the flag references and ensure no regressions occur.
5. Run tests for any code modified, and make sure they pass. If any tests fail, check your changes and make necessary
   modifications so that they pass again.
6. After all modifications, commit changes with `git add .; git commit -m "Remove references to #{flag_handle}"`.
</procedure>

<task>
Using your procedure, remove the flag #ARGUMENT from the codebase
</task>
