---
name: ccdeepseek
description: Delegate bounded coding, debugging, test-triage, refactor planning, implementation drafts, or cost-sensitive repetitive work from Codex to the local Claude Code CLI configured with DeepSeek, especially when the user mentions ccdeepseek, DeepSeek, deepseek-v4-pro, deepseek-v4-flash, cheaper/offloaded execution, or when Codex can save context by assigning a narrow task to DeepSeek. Always use the current Codex model to audit ccdeepseek output, diffs, and verification before accepting or reporting the result.
---

# CC DeepSeek

## Purpose

Use this skill to offload a bounded task to `claude --model deepseek-v4-pro` through the local DeepSeek Claude Code provider configuration while keeping Codex responsible for judgment, review, and final reporting.

## Delegation Policy

Use ccdeepseek for narrow, checkable work:

- coding and debugging drafts
- focused test failure analysis
- first-pass refactors
- command output and CI log triage
- low-risk implementation alternatives
- docs cleanup with concrete source files
- repetitive search, summarization, or comparison

Do not use ccdeepseek for secrets, credentials, destructive operations, production deploys, irreversible git operations, payment/auth/security-sensitive changes, final code review, final user answers, or anything Codex cannot independently verify.

## Required Workflow

1. Define a small task for DeepSeek: exact goal, relevant files, constraints, and expected evidence.
2. Snapshot local state first with `git status --porcelain` when working in a git repo.
3. Run `scripts/ccdeepseek.ps1` from this skill. Use read-only mode by default; add `-AllowEdits` only for a deliberately delegated code edit.
   - The wrapper prefers `C:\Users\<you>\.claude\settings.deepseek.json` when present, then falls back to normal Claude `settings.json`.
   - The default model id is `deepseek-v4-pro`.
   - For cheaper fast triage, pass `-Model deepseek-v4-flash` when the task is low-risk and easy to verify.
4. Read the wrapper output paths. Treat every ccdeepseek run as `pending Codex review`.
5. Codex must audit with the current Codex model before accepting the work:
   - inspect ccdeepseek output
   - inspect `git diff` and any changed files
   - run targeted tests, hooks, linters, or command-level verification when relevant
   - reject, patch, or refine the result if needed
6. Mark the ccdeepseek run reviewed with `scripts/ccdeepseek-mark-reviewed.ps1` after the Codex audit.
7. Report concisely: what DeepSeek did, what Codex verified, and any remaining risk.

Never let DeepSeek's own conclusion be the final answer. DeepSeek executes; Codex reviews.

## Commands

Read-only delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\ccdeepseek\scripts\ccdeepseek.ps1" `
  -Cwd (Get-Location).Path `
  -Prompt "Analyze this failing test output and return the likely root cause, files to inspect, and minimal fix plan."
```

Fast low-risk triage:

```powershell
& "$env:USERPROFILE\.codex\skills\ccdeepseek\scripts\ccdeepseek.ps1" `
  -Cwd (Get-Location).Path `
  -Model deepseek-v4-flash `
  -Prompt "Summarize the changed files and identify obvious documentation gaps only."
```

Editable delegation:

```powershell
& "$env:USERPROFILE\.codex\skills\ccdeepseek\scripts\ccdeepseek.ps1" `
  -Cwd (Get-Location).Path `
  -AllowEdits `
  -Prompt "Implement the localized fix in src/foo.ts only. Do not touch unrelated files. Run the focused test if available and summarize evidence."
```

Mark reviewed after Codex audit:

```powershell
& "$env:USERPROFILE\.codex\skills\ccdeepseek\scripts\ccdeepseek-mark-reviewed.ps1" `
  -MetaPath "C:\Users\harzva\.codex\ccdeepseek-runs\<run>-pending.json" `
  -Summary "Codex reviewed output, git diff, and focused tests; accepted with one local patch."
```

## Model Guidance

Reference DeepSeek's Anthropic-compatible API docs when provider behavior changes.

- Use `deepseek-v4-pro` as the default general coding and debugging delegation model.
- Use `deepseek-v4-flash` for quick, cheap, low-risk triage.
- Avoid deprecated aliases when current model ids are available.
- Keep prompts bounded: exact files, allowed edits, stop conditions, and required evidence.

## Hook Guard

The wrapper writes pending review metadata under `$env:USERPROFILE\.codex\ccdeepseek-runs`. If a future Stop hook watches these files, it should block final reporting when a ccdeepseek run for the current workspace is still unreviewed. The hook is a guardrail; the skill rule above is mandatory even if the hook is unavailable.

## Troubleshooting

- `failure_kind = api_auth_invalid`: the configured DeepSeek API key or token was rejected. Fix the Claude settings file or provider account before retrying.
- `failure_kind = api_connection_refused`: Claude CLI started but the configured endpoint refused the connection.
- `failure_kind = api_timeout`: retry with a smaller prompt, a lower-effort model, or a narrower file scope.
- `failure_kind = empty_cli_output`: retry with a smaller prompt, then inspect the wrapper output path.
- `stage = claude` with a non-zero exit code: Claude CLI started and returned its own error. Inspect `CCDEEPSEEK_OUTPUT` before retrying.
