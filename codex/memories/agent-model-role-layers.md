# Agent Model And Role Layers

When designing or invoking Agents in the user's AgentWorkOS, always separate two axes:

- Model execution layer: which model/provider/runtime executes a bounded task. Examples: `ccmimo`, `cckimi`, `ccdeepseek`.
- Task role layer: what responsibility, output standard, and workflow stance the agent takes. Examples: `role-planner`, project inventory manager, quality reviewer, memory rule manager.

Default rule:

- A model-layer skill is not a task role. It is an execution channel.
- A task role is not tied to one model. It can run on Codex, Kimi, DeepSeek, Mimo, or another verified channel.
- The actual working unit is `task role + model execution channel`.
- Any offloaded model-layer run must return to Codex current model for audit: output, diff, commands, tests, and remaining risk.
- Never put provider secrets from `model_acess.txt` into public repositories, README files, skill docs, screenshots, or long-term memories.
