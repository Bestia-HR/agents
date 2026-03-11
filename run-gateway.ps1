# Run OpenClaw gateway on Windows with project-local state and .env
# Usage: from the agent folder, run: .\run-gateway.ps1

$AgentDir = $PSScriptRoot
if (-not $AgentDir) { $AgentDir = Get-Location }

$StateDir = Join-Path $AgentDir ".openclaw-state"
$EnvFile  = Join-Path $AgentDir ".env"

# Use this project's state directory so config/sessions stay in the folder
$env:OPENCLAW_STATE_DIR = $StateDir

# Load .env if present (simple KEY=VALUE, no quotes)
if (Test-Path $EnvFile) {
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') {
            $key = $matches[1]
            $val = $matches[2].Trim()
            if ($val -match '^["''](.+)["'']\s*$') { $val = $matches[1] }
            [Environment]::SetEnvironmentVariable($key, $val, "Process")
        }
    }
}

# Start gateway (must be run from directory that contains openclaw.json or state dir)
Set-Location $AgentDir
openclaw gateway start
