---
name: ccmimo
description: Delegate bounded coding, refactor, log-triage, test-fix, documentation, or repetitive implementation work from Codex to the local Claude Code CLI configured with the mimo-v2.5-pro model, especially when the user mentions ccmimo, Claude, Mimo, mimo-v2.5-pro, cheaper/offloaded execution, or when Codex can save context by assigning a narrow task to Mimo. Always use the current Codex model to audit ccmimo output, diffs, and verification before accepting or reporting the result.
---

# CC Mimo

## Purpose

Use this skill to offload a bounded task to `claude --model mimo-v2.5-pro` while keeping Codex responsible for judgment, review, and final reporting.

## Delegation Policy

Use ccmimo for narrow, low-to-medium-risk work that can be checked afterward:

- mechanical or localized code edits
- first-pass implementation drafts
- dependency-free refactors
- log or CI failure triage
- test repair suggestions
- README/docs rewrites
- repetitive search, summarization, or comparison

Do not use ccmimo for secrets, credentials, destructive operations, production deploys, irreversible git operations, payment/auth/security-sensitive changes, final code review, final user answers, or anything Codex cannot independently verify.

## Required Workflow

1. Define a small task for Mimo: exact goal, relevant files, constraints, and expected evidence.
2. Snapshot local state first with `git status --porcelain` when working in a git repo.
3. Run `scripts/ccmimo.ps1` from this skill. Use read-only mode by default; add `-AllowEdits` only for a deliberately delegated code edit.
   - By default, the wrapper prefers `C:\Users\<you>\.claude\settings.mimo.json` when present, then falls back to normal Claude `settings.json`.
   - If Claude Code is configured through another provider file, pass `-SettingsPath` only for a currently verified, reachable settings file.
   - If the active Claude settings use a local `ANTHROPIC_BASE_URL`, the wrapper preflights that local port and fails early when the proxy/API service is not running.
   - Use `-SkipPreflight` only when you deliberately want Claude CLI to produce the raw API/provider error.
   - The only allowed Mimo model id is `mimo-v2.5-pro`.
4. Read the wrapper output paths. Treat every ccmimo run as `pending Codex review`.
5. Codex must audit with the current Codex model before accepting the work:
   - inspect ccmimo output
   - inspect `git diff` and any changed files
   - run targeted tests, hooks, linters, or command-level verification when relevant
   - reject, patch, or refine the result if needed
6. Mark the ccmimo run reviewed with `scripts/ccmimo-mark-reviewed.ps1` after the Codex audit.
7. Report concisely: what Mimo did, what Codex verified, and any remaining risk.

Never let Mimo's own conclusion be the final answer. Mimo executes; Codex reviews.

## Commands

Read-only delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\ccmimo\scripts\ccmimo.ps1" `
  -Cwd (Get-Location).Path `
  -Prompt "Analyze why the failing test points at the parser boundary. Return likely cause, files to inspect, and minimal fix plan."
```

Use an explicit settings file when needed:

```powershell
& "$env:USERPROFILE\.codex\skills\ccmimo\scripts\ccmimo.ps1" `
  -Cwd (Get-Location).Path `
  -SettingsPath "$env:USERPROFILE\.claude\settings.mimo.json" `
  -Prompt "Say OK only."
```

Provider/debug delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\ccmimo\scripts\ccmimo.ps1" `
  -Cwd (Get-Location).Path `
  -SkipPreflight `
  -Prompt "Say OK only. This run is only checking the Claude provider path."
```

Editable delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\ccmimo\scripts\ccmimo.ps1" `
  -Cwd (Get-Location).Path `
  -AllowEdits `
  -Prompt "Implement the localized fix in src/foo.ts only. Do not touch unrelated files. Run the focused test if available and summarize evidence."
```

Mark reviewed after Codex audit:

```powershell
& "$env:USERPROFILE\.codex\skills\ccmimo\scripts\ccmimo-mark-reviewed.ps1" `
  -MetaPath "C:\Users\harzva\.codex\ccmimo-runs\<run>-pending.json" `
  -Summary "Codex reviewed output, git diff, and focused tests; accepted with one local patch."
```

## Token Discipline

For long ccmimo work, keep user-visible updates sparse. Share only meaningful state changes: delegation started, result received, failure/root cause found, verification finished. Prefer one complete output file over repeated log polling.

## MiMo Parameter Guidance

Reference: Xiaomi MiMo platform quick-start documentation for model hyperparameters (`model-hyperparameters`).

These notes guide how to configure the upstream provider or direct MiMo API. Claude Code CLI does not currently expose all of these knobs directly through `ccmimo.ps1`; do not invent unsupported wrapper flags.

- Model id: use `mimo-v2.5-pro` as the default and only ccmimo model.
- Do not downgrade or switch to another Mimo model unless the provider's best model changes and the settings, wrapper, and skill docs are updated together.
- Coding, refactor, debugging, test repair: use low randomness. Prefer lower `temperature`; keep `top_p` conservative if the provider requires it. The goal is stable, reproducible, evidence-oriented output.
- Creative UI copy, brainstorming, naming, broad ideation: allow moderately higher randomness, but keep Codex responsible for pruning and verification.
- Do not tune every sampling knob at once. Change one of `temperature`, `top_p`, or `top_k` at a time so failures are explainable.
- If output repeats itself or loops, consider provider-level repetition controls such as `frequency_penalty` / `presence_penalty`, then retry with a smaller bounded prompt.
- For tool-calling or code-edit delegation, prefer clear stop conditions in the prompt: exact files, allowed commands, expected evidence, and "stop if blocked".
- For production-bound code, lower diversity is usually better than cleverness. Mimo should draft; Codex must audit.

## Hook Guard

The wrapper writes pending review metadata under `$env:USERPROFILE\.codex\ccmimo-runs`, including preflight failures. If the optional `ccmimo_audit_guard.ps1` Stop hook is installed, it reminds Codex before final response when a ccmimo run for the current workspace is still unreviewed. The hook is only a guardrail; the skill rule above is mandatory even if the hook is unavailable.

## Troubleshooting

- `stage = preflight` and `preflight_status = failed`: Claude Code is configured to use a local API/proxy URL that was not reachable. Start that service or pass `-SettingsPath` for a reachable provider.
- `failure_kind = api_auth_invalid`: the provider rejected the configured API key or token. Fix the Claude settings file or provider account before retrying.
- `failure_kind = api_connection_refused`: Claude CLI started but the configured API endpoint refused the connection.
- `failure_kind = empty_cli_output`: Claude CLI exited without useful stdout/stderr. Retry with `-SkipPreflight` or a smaller prompt, then inspect Claude telemetry if needed.
- `stage = claude` with a non-zero exit code: Claude CLI started and returned its own error. Inspect `CCMIMO_OUTPUT` before retrying.
