<#
.SYNOPSIS
    DotnetUtils - .NET development utilities.

.DESCRIPTION
    Functions to accelerate common .NET tasks: build, clean, run, test, restore,
    format, package management and process management.

.VERSION
    1.0.0
#>

# ========================================
# DOTNET - Help
# ========================================

function dn-help {
    Write-Host "`nDOTNET helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "dnrs";          Desc = "dotnet restore"; Params = $null },
        @{ Name = "dnb";           Desc = "dotnet build"; Params = "[ProjectPath] optional -> dnb ./src/MyProj" },
        @{ Name = "dnc";           Desc = "dotnet clean"; Params = $null },
        @{ Name = "dnc+";          Desc = "Delete bin/obj folders recursively"; Params = $null },
        @{ Name = "dnr";           Desc = "dotnet run"; Params = "[ProjectPath] optional -> dnr ./src/MyProj" },
        @{ Name = "dnt";           Desc = "dotnet test"; Params = $null },
        @{ Name = "dn-updt";       Desc = "List outdated NuGet packages"; Params = "[ProjectPath] optional -> dn-updt ./MyProject" },
        @{ Name = "dnv";           Desc = "Show .NET version"; Params = $null },
        @{ Name = "dn-purge";      Desc = "Kill active dotnet processes"; Params = $null },
        @{ Name = "dnf";           Desc = "Format code with CSharpier"; Params = $null },
        @{ Name = "dn-help";        Desc = "Show this help"; Params = $null }
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
# DOTNET - Build and Clean
# ========================================

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

function dnc {
    dotnet clean
}

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

function dnt {
    dotnet test
}

function dnrs {
    dotnet restore
}

# ========================================
# DOTNET - Information and Management
# ========================================

function dnv {
    dotnet --version
}

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

function dn-updt {
    param (
        [string]$ProjectPath = $PWD
    )

    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Error: Specified path does not exist: $ProjectPath" -ForegroundColor Red
        return
    }

    Write-Host "Searching for outdated packages in: $ProjectPath" -ForegroundColor Cyan
    Write-Host ""

    dotnet list $ProjectPath package --outdated
}

function dnf {
    dotnet csharpier format .
}
