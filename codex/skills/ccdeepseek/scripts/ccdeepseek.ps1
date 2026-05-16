param(
  [Parameter(Mandatory = $true)]
  [string]$Prompt,

  [string]$Model = "deepseek-v4-pro",
  [string]$Cwd = (Get-Location).Path,
  [string]$OutputPath = "",
  [string]$SettingsPath = "",
  [string[]]$AddDir = @(),
  [int]$PreflightTimeoutMs = 1500,

  [ValidateSet("low", "medium", "high", "xhigh", "max")]
  [string]$Effort = "medium",

  [switch]$SkipPreflight,
  [switch]$AllowEdits
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $false

function Get-ShortHash([string]$Text) {
  $sha = [System.Security.Cryptography.SHA256]::Create()
  try {
    $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
    $hash = $sha.ComputeHash($bytes)
    return ([BitConverter]::ToString($hash) -replace "-", "").Substring(0, 12).ToLowerInvariant()
  } finally {
    $sha.Dispose()
  }
}

function Get-FullHash([string]$Text) {
  $sha = [System.Security.Cryptography.SHA256]::Create()
  try {
    $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
    $hash = $sha.ComputeHash($bytes)
    return ([BitConverter]::ToString($hash) -replace "-", "").ToLowerInvariant()
  } finally {
    $sha.Dispose()
  }
}

function Get-ClaudeSettingsPath([string]$ExplicitPath) {
  if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
    return (Resolve-Path -LiteralPath $ExplicitPath).Path
  }

  $mimoPath = Join-Path $env:USERPROFILE ".claude\settings.deepseek.json"
  if (Test-Path -LiteralPath $mimoPath) {
    return (Resolve-Path -LiteralPath $mimoPath).Path
  }

  $defaultPath = Join-Path $env:USERPROFILE ".claude\settings.json"
  if (Test-Path -LiteralPath $defaultPath) {
    return (Resolve-Path -LiteralPath $defaultPath).Path
  }

  return ""
}

function Get-ClaudeBaseUrl([string]$SettingsFile) {
  if ([string]::IsNullOrWhiteSpace($SettingsFile) -or -not (Test-Path -LiteralPath $SettingsFile)) {
    return $env:ANTHROPIC_BASE_URL
  }

  try {
    $settings = Get-Content -LiteralPath $SettingsFile -Raw | ConvertFrom-Json
    if ($settings.env -and $settings.env.ANTHROPIC_BASE_URL) {
      return [string]$settings.env.ANTHROPIC_BASE_URL
    }
  } catch {
    Write-Warning "Could not parse Claude settings file for preflight: $SettingsFile"
  }

  return $env:ANTHROPIC_BASE_URL
}

function Get-SafeBaseUrl([string]$BaseUrl) {
  if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
    return ""
  }

  $uri = $null
  if (-not [System.Uri]::TryCreate($BaseUrl, [System.UriKind]::Absolute, [ref]$uri)) {
    return "<invalid-url>"
  }

  $builder = [System.UriBuilder]::new($uri)
  $builder.UserName = ""
  $builder.Password = ""
  $builder.Query = ""
  return $builder.Uri.GetLeftPart([System.UriPartial]::Authority)
}

function Test-LocalBaseUrl([string]$BaseUrl, [int]$TimeoutMs) {
  if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
    return
  }

  $uri = $null
  if (-not [System.Uri]::TryCreate($BaseUrl, [System.UriKind]::Absolute, [ref]$uri)) {
    return
  }

  if ($uri.Host -notin @("127.0.0.1", "localhost", "::1")) {
    return
  }

  $port = $uri.Port
  if ($port -lt 0) {
    $port = if ($uri.Scheme -eq "https") { 443 } else { 80 }
  }

  $client = [System.Net.Sockets.TcpClient]::new()
  try {
    $async = $client.BeginConnect($uri.Host, $port, $null, $null)
    if (-not $async.AsyncWaitHandle.WaitOne($TimeoutMs, $false)) {
      throw "Timed out connecting to $($uri.Host):$port"
    }
    $client.EndConnect($async)
  } catch {
    throw "Claude API base URL is local but unreachable: $(Get-SafeBaseUrl $BaseUrl). Start the local API/proxy service, pass -SettingsPath pointing to a reachable Claude settings file, or use -SkipPreflight to let Claude CLI report the raw API error."
  } finally {
    $client.Close()
  }
}

function Get-FailureKind([int]$ExitCode, [string]$Stage, [string]$PreflightStatus, [string]$OutputText) {
  if ($ExitCode -eq 0) {
    return "none"
  }

  if ($Stage -eq "preflight" -or $PreflightStatus -eq "failed") {
    return "preflight_unreachable"
  }

  if ($OutputText -match "(?i)401|invalid api key|failed to authenticate|unauthorized") {
    return "api_auth_invalid"
  }

  if ($OutputText -match "(?i)connectionrefused|unable to connect|connection refused") {
    return "api_connection_refused"
  }

  if ($OutputText -match "(?i)timeout|timed out|deadline") {
    return "api_timeout"
  }

  if ([string]::IsNullOrWhiteSpace($OutputText)) {
    return "empty_cli_output"
  }

  return "claude_cli_failed"
}

function Write-RunRecord(
  [string]$MetaPath,
  [string]$OutputPath,
  [string]$OutputText,
  [int]$ExitCode,
  [string]$Stage,
  [string]$PreflightStatus,
  [string]$PreflightMessage,
  [string]$StartedAt,
  [Diagnostics.Stopwatch]$Stopwatch
) {
  Set-Content -LiteralPath $OutputPath -Value $OutputText -Encoding UTF8
  $failureKind = Get-FailureKind $ExitCode $Stage $PreflightStatus $OutputText

  $meta = [pscustomobject]@{
    tool = "ccdeepseek"
    model = $Model
    cwd = $resolvedCwd
    cwd_hash = $cwdHash
    started_at = $StartedAt
    finished_at = (Get-Date).ToString("o")
    duration_seconds = [Math]::Round($Stopwatch.Elapsed.TotalSeconds, 3)
    exit_code = $ExitCode
    failure_kind = $failureKind
    stage = $Stage
    permission_mode = $mode
    settings_path = $resolvedSettingsPath
    api_base_url = Get-SafeBaseUrl $baseUrl
    preflight_status = $PreflightStatus
    preflight_message = $PreflightMessage
    output_path = $OutputPath
    prompt_sha256 = Get-FullHash $Prompt
    codex_review_required = $true
    codex_reviewed = $false
    review_instruction = "Codex current model must inspect this output, git diff/changed files, and targeted verification before accepting or reporting the result."
  }

  $meta | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $MetaPath -Encoding UTF8

  Write-Output "CCDEEPSEEK_OUTPUT=$OutputPath"
  Write-Output "CCDEEPSEEK_PENDING_REVIEW=$MetaPath"
  Write-Output "CCDEEPSEEK_EXIT_CODE=$ExitCode"
}

$resolvedCwd = (Resolve-Path -LiteralPath $Cwd).Path
Set-Location -LiteralPath $resolvedCwd

$claudeCommand = Get-Command claude -ErrorAction Stop
$resolvedSettingsPath = Get-ClaudeSettingsPath $SettingsPath
$baseUrl = Get-ClaudeBaseUrl $resolvedSettingsPath
$runRoot = Join-Path $env:USERPROFILE ".codex\ccdeepseek-runs"
New-Item -ItemType Directory -Force -Path $runRoot | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$cwdHash = Get-ShortHash $resolvedCwd
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $OutputPath = Join-Path $runRoot "$timestamp-$cwdHash-output.txt"
}
$metaPath = Join-Path $runRoot "$timestamp-$cwdHash-pending.json"

$mode = if ($AllowEdits) { "acceptEdits" } else { "plan" }
$startedAt = (Get-Date).ToString("o")
$sw = [Diagnostics.Stopwatch]::StartNew()
$preflightStatus = if ($SkipPreflight) { "skipped" } else { "passed" }
$preflightMessage = ""

if (-not $SkipPreflight) {
  try {
    Test-LocalBaseUrl $baseUrl $PreflightTimeoutMs
  } catch {
    $preflightStatus = "failed"
    $preflightMessage = $_.Exception.Message
    $sw.Stop()
    Write-RunRecord `
      -MetaPath $metaPath `
      -OutputPath $OutputPath `
      -OutputText $preflightMessage `
      -ExitCode 1 `
      -Stage "preflight" `
      -PreflightStatus $preflightStatus `
      -PreflightMessage $preflightMessage `
      -StartedAt $startedAt `
      -Stopwatch $sw
    exit 1
  }
}

$systemPrompt = @"
You are ccdeepseek, a delegated worker invoked by Codex.
Use the configured Claude Code runtime with model $Model.
Stay inside the bounded task. Keep output concise and evidence-oriented.
For coding, refactor, tests, and troubleshooting tasks, prefer deterministic execution: make minimal changes, avoid creative alternatives unless asked, and do not invent evidence.
If editing is allowed, list exact changed files, commands run, and verification evidence.
Do not claim final approval. The current Codex model must audit your output, diffs, and tests after you finish.
If blocked or unsure, stop and state the blocker.
"@

$args = @(
  "-p",
  "--model", $Model,
  "--effort", $Effort,
  "--output-format", "text",
  "--no-session-persistence",
  "--append-system-prompt", $systemPrompt,
  "--permission-mode", $mode
)

if (-not [string]::IsNullOrWhiteSpace($resolvedSettingsPath)) {
  $args += @("--settings", $resolvedSettingsPath)
}

foreach ($dir in $AddDir) {
  if (-not [string]::IsNullOrWhiteSpace($dir)) {
    $args += @("--add-dir", $dir)
  }
}

$args += $Prompt

$output = & $claudeCommand.Source @args 2>&1
$exitCode = $LASTEXITCODE
$sw.Stop()

$outputText = ($output | Out-String).TrimEnd()
Write-RunRecord `
  -MetaPath $metaPath `
  -OutputPath $OutputPath `
  -OutputText $outputText `
  -ExitCode $exitCode `
  -Stage "claude" `
  -PreflightStatus $preflightStatus `
  -PreflightMessage $preflightMessage `
  -StartedAt $startedAt `
  -Stopwatch $sw

if ($exitCode -ne 0) {
  exit $exitCode
}

