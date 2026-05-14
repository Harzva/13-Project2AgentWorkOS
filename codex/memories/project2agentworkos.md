# Project2AgentWorkOS Memory

When a task involves projects, Codex threads, failure reviews, unfinished ideas, or repeated workflow mistakes, treat the work as a Project2AgentWorkOS extraction task.

Default behavior:

- Select a role from the Agent role library before executing.
- Convert useful output into one or more AgentWorkOS layers: Agent, Memory, Skills, MCP, Workflow, Rules.
- Prefer public-safe distilled artifacts over raw private logs.
- Do not call a project complete until it has evidence: README, visual proof, release path, or archive decision.
- If the task touches Windows Node CLI tools, prefer `.cmd` shims such as `npx.cmd` and do not change PowerShell execution policy.

