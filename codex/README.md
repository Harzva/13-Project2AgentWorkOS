# Codex Integration

This folder contains public-safe AgentWorkOS components that can be installed into local `.codex`.

It exists to prove the project works on itself.

## What Can Be Installed

| Source path | Local Codex target | Purpose |
|---|---|---|
| `codex/skills/project2agentworkos/` | `<codex-home>/skills/project2agentworkos/` | Trigger Project2AgentWorkOS workflows inside Codex |
| `codex/skills/ccmimo/` | `<codex-home>/skills/ccmimo/` | Delegate bounded work to Mimo through Claude Code, then audit with Codex |
| `codex/skills/cckimi/` | `<codex-home>/skills/cckimi/` | Delegate bounded work to Kimi through Claude Code, then audit with Codex |
| `codex/skills/ccdeepseek/` | `<codex-home>/skills/ccdeepseek/` | Delegate bounded work to DeepSeek through Claude Code, then audit with Codex |
| `codex/memories/project2agentworkos.md` | `<codex-home>/memories/project2agentworkos.md` | Durable behavior rule |
| `codex/memories/agent-model-role-layers.md` | `<codex-home>/memories/agent-model-role-layers.md` | Keep model execution channels separate from task roles |
| `codex/memories/cc-provider-model-policy.md` | `<codex-home>/memories/cc-provider-model-policy.md` | Keep CC provider wrappers on strongest allowed models |
| `codex/rules/project2agentworkos.rules` | `<codex-home>/rules/project2agentworkos.rules` | Public-safe execution preference notes |
| `docs/HOOKS_AND_AGENTWORKOS.md` | hook design reference | Hook candidates and lifecycle discipline before any local hook is installed |

## Boundary

Do not copy raw sessions, auth files, sqlite databases, or private config into this repository.

Only copy distilled content that can safely become public.

Provider settings such as `settings.kimi.json`, `settings.deepseek.json`, and `model_acess.txt` stay local. The public skills describe the workflow and wrapper behavior, not the secrets.
