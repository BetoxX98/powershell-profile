<#
.SYNOPSIS
    PowerShellUtils - General PowerShell session utilities.

.DESCRIPTION
    Functions for everyday terminal use: clear, open Explorer,
    open Windows Terminal, and profile management.

.VERSION
    1.0.0
#>

# ========================================
# POWERSHELL - Help
# ========================================

function pws-help {
    Write-Host "`nPOWERSHELL helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "c";        Desc = "Clear screen"; Params = $null },
        @{ Name = "open";     Desc = "Open current directory in Explorer"; Params = $null },
        @{ Name = "terminal"; Desc = "Open new Windows Terminal"; Params = "[-claude] open with claude CLI" },
        @{ Name = "pws-p";    Desc = "Edit profile in VSCode"; Params = $null },
        @{ Name = "pws-s";    Desc = "Reload profile"; Params = $null },
        @{ Name = "pws-l";    Desc = "List pws-* functions"; Params = $null },
        @{ Name = "pws-help"; Desc = "Show this help"; Params = $null }
    )

    foreach ($cmd in $commands) {
        Write-Host ("  {0,-16} {1}" -f $cmd.Name, $cmd.Desc) -ForegroundColor Green
        if ($cmd.Params) {
            Write-Host ("{0,18} {1}" -f "", $cmd.Params) -ForegroundColor Yellow
        }
    }

    Write-Host ""
}

# ========================================
# POWERSHELL - Session utilities
# ========================================

function c {
    cls
    Write-Host ""
}

function open {
    start .
}

function terminal {
    param(
        [switch]$claude
    )

    if ($claude) {
        wt -d . powershell -NoExit -Command "claude"
    } else {
        wt -d .
    }
}

# ========================================
# POWERSHELL - Profile management
# ========================================

function pws-p { CODE $PROFILE }
function pws-s { . $PROFILE }
function pws-l { Get-Command -Name pws-* -CommandType Function }
