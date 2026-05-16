param(
  [Parameter(Mandatory = $true)]
  [string]$MetaPath,

  [Parameter(Mandatory = $true)]
  [string]$Summary
)

$ErrorActionPreference = "Stop"

$resolvedMetaPath = (Resolve-Path -LiteralPath $MetaPath).Path
$meta = Get-Content -LiteralPath $resolvedMetaPath -Raw | ConvertFrom-Json

$meta | Add-Member -NotePropertyName codex_reviewed -NotePropertyValue $true -Force
$meta | Add-Member -NotePropertyName codex_reviewed_at -NotePropertyValue (Get-Date).ToString("o") -Force
$meta | Add-Member -NotePropertyName codex_review_summary -NotePropertyValue $Summary -Force

$meta | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $resolvedMetaPath -Encoding UTF8
Write-Output "CCMIMO_REVIEWED=$resolvedMetaPath"
