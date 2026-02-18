<#
.SYNOPSIS
    YarnUtils - JavaScript/Yarn dependency management utilities.

.DESCRIPTION
    Functions to manage JavaScript projects with Yarn.

.VERSION
    1.0.0
#>

# ========================================
# YARN - Help
# ========================================

function yarn-help {
    Write-Host "`nYARN helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "pws-isyarn"; Desc = "yarn install + yarn start"; Params = $null },
        @{ Name = "yarn-help";  Desc = "Show this help"; Params = $null }
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
# YARN - JavaScript dependency management
# ========================================

function pws-isyarn {
    yarn
    yarn start
}
