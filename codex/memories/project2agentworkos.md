# Project2AgentWorkOS Memory

When a task involves projects, Codex threads, failure reviews, unfinished ideas, or repeated workflow mistakes, treat the work as a Project2AgentWorkOS extraction task.

Default behavior:

- Select a role from the Agent role library before executing.
- Separate model execution channels (`ccmimo`, `cckimi`, `ccdeepseek`) from task roles (`role-planner`, project inventory, quality reviewer, memory rule manager); combine them explicitly when delegating.
- Keep `cc*` provider skills on the strongest allowed model; only DeepSeek may use a `pro`/`flash` two-tier policy.
- Convert useful output into one or more AgentWorkOS layers: Agent, Memory, Skills, MCP, Workflow, Rules, Hooks.
- Prefer public-safe distilled artifacts over raw private logs.
- Do not call a project complete until it has evidence: README, visual proof, release path, or archive decision.
- If the task touches Windows Node CLI tools, prefer `.cmd` shims such as `npx.cmd` and do not change PowerShell execution policy.
- Treat Hook as execution discipline: when a repeated failure can be checked at a lifecycle point, capture it as a hook candidate instead of leaving it only as advice.
