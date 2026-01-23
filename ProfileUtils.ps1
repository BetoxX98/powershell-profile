<#
.SYNOPSIS
    PowerShell Profile Utilities - Utilities for .NET, Docker and more development.

.DESCRIPTION
    Set of functions to accelerate common development tasks.
    Includes utilities for dotnet, ASP.NET Core, Yarn and Docker.

.AUTHOR
    Your Name

.VERSION
    1.0.0
#>

# ========================================
# DOTNET - Help functions
# ========================================

<#
.SYNOPSIS
    Display help with available .NET commands.

.DESCRIPTION
    Prints a formatted list of all available commands with their description and optional parameters.

.EXAMPLE
    dn-help
#>
function dn-help {
    Write-Host "`nDOTNET helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "dnrs";     Desc = "dotnet restore"; Params = $null },
        @{ Name = "dnb";      Desc = "dotnet build"; Params = "[ProjectPath] optional -> dnb ./src/MyProj" },
        @{ Name = "dnc";      Desc = "dotnet clean"; Params = $null },
        @{ Name = "dnc+";     Desc = "Delete bin/obj folders recursively"; Params = $null },
        @{ Name = "dnr";      Desc = "dotnet run"; Params = "[ProjectPath] optional -> dnr ./src/MyProj" },
        @{ Name = "dnt";      Desc = "dotnet test"; Params = $null },
        @{ Name = "dn-updt";  Desc = "List outdated NuGet packages"; Params = "[ProjectPath] optional -> dn-updates ./MyProject" },
        @{ Name = "dnv";      Desc = "Show .NET version"; Params = $null },
        @{ Name = "dn-purge"; Desc = "Kill active dotnet processes"; Params = $null },
        @{ Name = "dnf";      Desc = "Format code with CSharpier"; Params = $null },
        @{ Name = "dn-help";  Desc = "Show this help"; Params = $null }
    )

    foreach ($cmd in $commands) {
        Write-Host ("  {0,-10} {1}" -f $cmd.Name, $cmd.Desc) -ForegroundColor Green
        if ($cmd.Params) {
            Write-Host ("{0,12} {1}" -f "", $cmd.Params) -ForegroundColor Yellow
        }
    }

    Write-Host ""
}

# ========================================
# DOTNET - Build and Clean
# ========================================

<#
.SYNOPSIS
    Compiles a .NET project or solution.

.DESCRIPTION
    Executes 'dotnet build' with validation and visual feedback of success/error.

.PARAMETER ProjectPath
    Path of the project to compile. Default is the current directory.

.EXAMPLE
    dnb
    dnb ./src/MyProject
#>
function dnb {
    param (
        [string]$ProjectPath = $PWD
    )
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Error: Path does not exist: $ProjectPath" -ForegroundColor Red
        return
    }
    
    cls
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    dotnet build $ProjectPath
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        cls
        Write-Host ""
        Write-Host "- " -ForegroundColor White -NoNewline
        Write-Host "BUILD SUCCESS" -ForegroundColor Green -NoNewline
        Write-Host " -" -ForegroundColor White
    }
    Write-Host ""
}

<#
.SYNOPSIS
    Cleans build artifacts.

.DESCRIPTION
    Executes 'dotnet clean' in the current project.

.EXAMPLE
    dnc
#>
function dnc {
    dotnet clean
}

<#
.SYNOPSIS
    Recursively deletes bin and obj folders.

.DESCRIPTION
    Searches and deletes all bin and obj folders in the current directory tree.
    Useful for deeply cleaning projects.

.EXAMPLE
    dnc+
#>
function dnc+ {
    Get-ChildItem -Path . -Include bin, obj -Recurse -Directory | ForEach-Object {
        Write-Host -NoNewline "Deleting: " -ForegroundColor Green
        Write-Host "$($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ========================================
# DOTNET - Run and Test
# ========================================

<#
.SYNOPSIS
    Runs a .NET project.

.DESCRIPTION
    Executes 'dotnet run' in the specified project or the current one.

.PARAMETER ProjectPath
    Path of the project to run. Default is the current directory.

.EXAMPLE
    dnr
    dnr ./src/MyProject
#>
function dnr {
    param (
        [string]$ProjectPath = $PWD
    )
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Error: Path does not exist: $ProjectPath" -ForegroundColor Red
        return
    }
    
    dotnet run --project $ProjectPath
}

<#
.SYNOPSIS
    Runs project tests.

.DESCRIPTION
    Executes 'dotnet test' in the current project.

.EXAMPLE
    dnt
#>
function dnt {
    dotnet test
}

<#
.SYNOPSIS
    Restores NuGet dependencies.

.DESCRIPTION
    Executes 'dotnet restore' in the current project.

.EXAMPLE
    dnrs
#>
function dnrs {
    dotnet restore
}

# ========================================
# DOTNET - Information and Management
# ========================================

<#
.SYNOPSIS
    Shows the installed .NET version.

.DESCRIPTION
    Executes 'dotnet --version' to display the installed SDK version.

.EXAMPLE
    dnv
#>
function dnv {
    dotnet --version
}

<#
.SYNOPSIS
    Kills all active dotnet processes.

.DESCRIPTION
    Finds and terminates all running dotnet processes.
    Useful for freeing resources when processes are stuck.

.EXAMPLE
    dn-purge
#>
function dn-purge {
    $dotnetProcesses = Get-Process -Name "dotnet" -ErrorAction SilentlyContinue
    if ($dotnetProcesses) {
        $dotnetProcesses | ForEach-Object {
            Write-Host "Stopping .NET process: $($_.Id) ($($_.Path))" -ForegroundColor Yellow
            Stop-Process -Id $_.Id -Force
        }
        Write-Host ".NET processes terminated." -ForegroundColor Green
    }
    else {
        Write-Host "No running .NET processes found." -ForegroundColor Cyan
    }
}

<#
.SYNOPSIS
    Lists outdated NuGet packages.

.DESCRIPTION
    Shows a list of NuGet packages that have newer versions available.

.PARAMETER ProjectPath
    Path of the project to analyze. Default is the current directory.

.EXAMPLE
    dn-updt
    dn-updt ./src/MyProject
#>
function dn-updt {
    param (
        [string]$ProjectPath
    )

    if (-not $ProjectPath) {
        $ProjectPath = $PWD
    }

    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Error: Specified path does not exist: $ProjectPath" -ForegroundColor Red
        return
    }

    Write-Host "Searching for outdated packages in: $ProjectPath" -ForegroundColor Cyan
    Write-Host ""

    dotnet list $ProjectPath package --outdated
}

<#
.SYNOPSIS
    Formats C# code with CSharpier.

.DESCRIPTION
    Executes CSharpier to automatically format all C# code in the current project.

.EXAMPLE
    dnf
#>
function dnf {
    dotnet csharpier format .
}

# ========================================
# ASP.NET CORE - Environment Configuration
# ========================================

<#
.SYNOPSIS
    Sets environment to Development.

.DESCRIPTION
    Configures the ASPNETCORE_ENVIRONMENT environment variable to 'Development'.
    Sets it both in the current session and persistently.

.EXAMPLE
    asp-set-devEnv
#>
function asp-set-devEnv {
    setx ASPNETCORE_ENVIRONMENT "Development"
    $env:ASPNETCORE_ENVIRONMENT = 'Development'
    Write-Host "ASPNETCORE_ENVIRONMENT set to: Development" -ForegroundColor Green
}

<#
.SYNOPSIS
    Sets environment to Production.

.DESCRIPTION
    Configures the ASPNETCORE_ENVIRONMENT environment variable to 'Production'.
    Sets it both in the current session and persistently.

.EXAMPLE
    asp-set-prodEnv
#>
function asp-set-prodEnv {
    setx ASPNETCORE_ENVIRONMENT "Production"
    $env:ASPNETCORE_ENVIRONMENT = 'Production'
    Write-Host "ASPNETCORE_ENVIRONMENT set to: Production" -ForegroundColor Green
}

# ========================================
# YARN - JavaScript dependency management
# ========================================

<#
.SYNOPSIS
    Initializes and starts a Yarn project.

.DESCRIPTION
    Executes 'yarn' to install dependencies and then 'yarn start' to start the project.

.EXAMPLE
    pws-isyarn
#>
function pws-isyarn {
    yarn
    yarn start
}

# ========================================
# DOCKER - Container management
# ========================================

<#
.SYNOPSIS
    Purges all Docker resources.

.DESCRIPTION
    Stops and removes all Docker containers, volumes and images.
    Optional: keep images with the -KeepImages switch.

.PARAMETER KeepImages
    If specified, Docker images will not be removed.

.EXAMPLE
    docker-purge
    docker-purge -KeepImages
#>
function docker-purge {
    param([switch]$KeepImages)

    Write-Host "Stopping Docker containers..." -ForegroundColor Cyan
    docker container stop $(docker container ls -aq) | Out-Null
    
    Write-Host "Removing containers..." -ForegroundColor Cyan
    docker container rm $(docker container ls -aq) -f | Out-Null
    
    Write-Host "Removing volumes..." -ForegroundColor Cyan
    docker volume rm $(docker volume ls -q) -f | Out-Null
    
    if (-not $KeepImages) {
        Write-Host "Removing images..." -ForegroundColor Cyan
        docker image rm $(docker image ls -aq) -f | Out-Null
    }
    
    Write-Host "Purge completed." -ForegroundColor Green
}
