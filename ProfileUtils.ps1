<#
.SYNOPSIS
    ProfileUtils - Hub loader. Imports all utility modules.

.DESCRIPTION
    Loading this file loads all modules.
    Each module under /modules/ can also be loaded individually.
#>

. "$PSScriptRoot\modules\PowerShellUtils.ps1"
. "$PSScriptRoot\modules\DotnetUtils.ps1"
. "$PSScriptRoot\modules\AspNetUtils.ps1"
. "$PSScriptRoot\modules\DockerUtils.ps1"
. "$PSScriptRoot\modules\YarnUtils.ps1"

function dn-help {
    $helpers = @('pws-help', 'dn-help-dotnet', 'asp-help', 'docker-help', 'yarn-help')
    foreach ($helper in $helpers) {
        if (Get-Command $helper -ErrorAction SilentlyContinue) {
            & $helper
        }
    }
}
