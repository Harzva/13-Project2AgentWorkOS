---
name: cckimi
description: Delegate bounded coding, long-context reading, documentation, refactor planning, log-triage, or repetitive implementation work from Codex to the local Claude Code CLI configured with the best Kimi/Moonshot model, especially when the user mentions cckimi, Kimi, Moonshot, kimi-k2.6, long context, cheaper/offloaded execution, or when Codex can save context by assigning a narrow task to Kimi. Always use the current Codex model to audit cckimi output, diffs, and verification before accepting or reporting the result.
---

# CC Kimi

## Purpose

Use this skill to offload a bounded task to `claude --model kimi-k2.6` through the local Kimi/Moonshot Claude Code provider configuration while keeping Codex responsible for judgment, review, and final reporting.

## Delegation Policy

Use cckimi for narrow, checkable work:

- long-context project or document reading
- first-pass code search and summarization
- README, tutorial, and article drafting
- localized implementation drafts
- refactor planning
- log or CI failure triage
- repetitive comparison or extraction tasks

Do not use cckimi for secrets, credentials, destructive operations, production deploys, irreversible git operations, payment/auth/security-sensitive changes, final code review, final user answers, or anything Codex cannot independently verify.

## Required Workflow

1. Define a small task for Kimi: exact goal, relevant files, constraints, and expected evidence.
2. Snapshot local state first with `git status --porcelain` when working in a git repo.
3. Run `scripts/cckimi.ps1` from this skill. Use read-only mode by default; add `-AllowEdits` only for a deliberately delegated code edit.
   - The wrapper prefers `C:\Users\<you>\.claude\settings.kimi.json` when present, then falls back to normal Claude `settings.json`.
   - The only allowed model id is `kimi-k2.6`.
4. Read the wrapper output paths. Treat every cckimi run as `pending Codex review`.
5. Codex must audit with the current Codex model before accepting the work:
   - inspect cckimi output
   - inspect `git diff` and any changed files
   - run targeted tests, hooks, linters, or command-level verification when relevant
   - reject, patch, or refine the result if needed
6. Mark the cckimi run reviewed with `scripts/cckimi-mark-reviewed.ps1` after the Codex audit.
7. Report concisely: what Kimi did, what Codex verified, and any remaining risk.

Never let Kimi's own conclusion be the final answer. Kimi executes; Codex reviews.

## Commands

Read-only delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\cckimi\scripts\cckimi.ps1" `
  -Cwd (Get-Location).Path `
  -Prompt "Read the docs folder and summarize duplicated concepts, missing structure, and a minimal cleanup plan."
```

Editable delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\cckimi\scripts\cckimi.ps1" `
  -Cwd (Get-Location).Path `
  -AllowEdits `
  -Prompt "Update docs/usage.md only. Keep the existing style, add the missing Windows note, and list verification evidence."
```

Use an explicit settings file when needed:

```powershell
& "$env:USERPROFILE\.codex\skills\cckimi\scripts\cckimi.ps1" `
  -Cwd (Get-Location).Path `
  -SettingsPath "$env:USERPROFILE\.claude\settings.kimi.json" `
  -Prompt "Say OK only."
```

Mark reviewed after Codex audit:

```powershell
& "$env:USERPROFILE\.codex\skills\cckimi\scripts\cckimi-mark-reviewed.ps1" `
  -MetaPath "C:\Users\harzva\.codex\cckimi-runs\<run>-pending.json" `
  -Summary "Codex reviewed output, git diff, and focused verification; accepted."
```

## Model Guidance

Reference the Kimi/Moonshot Agent/Claude Code support docs when provider behavior changes.

- Use `kimi-k2.6` as the default and only cckimi model.
- Do not downgrade or switch to another Kimi model unless the provider's best model changes and the settings, wrapper, and skill docs are updated together.
- Prefer cckimi when the task is context-heavy and the expected output is easy for Codex to check.
- Keep prompts bounded: exact files, allowed edits, stop conditions, and required evidence.

## Hook Guard

The wrapper writes pending review metadata under `$env:USERPROFILE\.codex\cckimi-runs`. If a future Stop hook watches these files, it should block final reporting when a cckimi run for the current workspace is still unreviewed. The hook is a guardrail; the skill rule above is mandatory even if the hook is unavailable.

## Troubleshooting

- `failure_kind = api_auth_invalid`: the configured Kimi API key or token was rejected. Fix the Claude settings file or provider account before retrying.
- `failure_kind = api_connection_refused`: Claude CLI started but the configured endpoint refused the connection.
- `failure_kind = api_timeout`: retry with a smaller prompt, a lower-effort model, or a narrower file scope.
- `failure_kind = empty_cli_output`: retry with a smaller prompt, then inspect the wrapper output path.
- `stage = claude` with a non-zero exit code: Claude CLI started and returned its own error. Inspect `CCKIMI_OUTPUT` before retrying.
