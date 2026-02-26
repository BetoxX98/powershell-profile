<#
.SYNOPSIS
    ProfileUtils - Hub loader. Imports all utility modules.

.DESCRIPTION
    Loading this file loads all modules.
    Each module under /modules/ can also be loaded individually.
    Works both as a local file (dot-sourced) and via iwr | iex from GitHub.
#>

$_modules = @(
    'PowerShellUtils',
    'DotnetUtils',
    'AspNetUtils',
    'DockerUtils',
    'YarnUtils',
    'GitUtils'
)

if ($PSScriptRoot) {
    foreach ($_mod in $_modules) {
        . "$PSScriptRoot\modules\$_mod.ps1"
    }
} else {
    $_baseUrl = "https://raw.githubusercontent.com/BetoxX98/powershell-profile/main"
    foreach ($_mod in $_modules) {
        iwr "$_baseUrl/modules/$_mod.ps1" -UseBasicParsing | Select-Object -ExpandProperty Content | Invoke-Expression
    }
}

Remove-Variable _modules, _baseUrl -ErrorAction SilentlyContinue

function profile-help {
    $helpers = @('pws-help', 'dn-help', 'asp-help', 'docker-help', 'yarn-help', 'git-help')
    foreach ($helper in $helpers) {
        if (Get-Command $helper -ErrorAction SilentlyContinue) {
            & $helper
        }
    }
}
