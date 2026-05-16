# CC Provider Model Policy

For the user's `cc*` model-execution skills, default to the best available model per provider and restrict wrapper model choices so accidental downgrades do not happen.

Current policy:

- `ccmimo`: only use `mimo-v2.5-pro`.
- `cckimi`: only use `kimi-k2.6`.
- `ccdeepseek`: use `deepseek-v4-pro` by default; allow `deepseek-v4-flash` only for cheap, fast, low-risk triage.

When a provider's best model changes, update these files together:

- local Claude provider settings under `%USERPROFILE%\.claude\settings.*.json`
- local skill wrapper `ValidateSet`
- local skill `SKILL.md`
- public-safe Project2AgentWorkOS copies under `codex/skills/`

Never use deprecated aliases or cheaper models silently when the user expects the strongest model.
