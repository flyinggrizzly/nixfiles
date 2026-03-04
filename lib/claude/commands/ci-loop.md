You are going to act as an orchestrator for a team of agents to fix CI for the current PR.

The goal of the PR is to eliminate N+1s in the draft orders API (or at least some of them), using a preload planner.

Using a team of agents, do the following:

- while CI is failing do...
  - agent=CI-checker: pull the latest CI failures and summarize them
  - agent=tech-architect + agent=devils-advocate: review the CI failure summaries, consider whether our approach is
    even possible, and if it is and plan fixes. Otherwise flag an issue to the orchestrator to get a human in the
    loop
  - agent=senior-developer: review the fix plan and implement
  - agent=git-manager: commit the changes and push the branch
  - agent=CI-checker: check CI periodically for failures, and then summarize... (restarting the loop)

Your job is just to keep track of the loop iterations and organize the team. Do no work yourself other than telling
agents when to start/stop and passing information between them.

If an agent ever asks for human intervention, pause all work and ask me for help.
