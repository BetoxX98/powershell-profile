<#
.SYNOPSIS
    AspNetUtils - ASP.NET Core environment utilities.

.DESCRIPTION
    Functions to manage the ASPNETCORE_ENVIRONMENT variable
    for ASP.NET Core projects.

.VERSION
    1.0.0
#>

# ========================================
# ASP.NET CORE - Help
# ========================================

function asp-help {
    Write-Host "`nASP.NET CORE helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "asp-set-devEnv";  Desc = "Set ASPNETCORE_ENVIRONMENT to Development"; Params = $null },
        @{ Name = "asp-set-prodEnv"; Desc = "Set ASPNETCORE_ENVIRONMENT to Production"; Params = $null },
        @{ Name = "asp-help";        Desc = "Show this help"; Params = $null }
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
# ASP.NET CORE - Environment Configuration
# ========================================

function asp-set-devEnv {
    setx ASPNETCORE_ENVIRONMENT "Development"
    $env:ASPNETCORE_ENVIRONMENT = 'Development'
    Write-Host "ASPNETCORE_ENVIRONMENT set to: Development" -ForegroundColor Green
}

function asp-set-prodEnv {
    setx ASPNETCORE_ENVIRONMENT "Production"
    $env:ASPNETCORE_ENVIRONMENT = 'Production'
    Write-Host "ASPNETCORE_ENVIRONMENT set to: Production" -ForegroundColor Green
}
