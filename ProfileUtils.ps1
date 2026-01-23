# ========================================
# Dotnet Utility Functions
# ========================================

$dotnetUtilsUrl = "https://raw.githubusercontent.com/BetoxX98/powershell-profile/main/DotnetUtils.ps1"
Invoke-Expression (Invoke-WebRequest -Uri $dotnetUtilsUrl -UseBasicParsing).Content

function dn-help {
    Write-Host "`nDOTNET helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "dnrs";     Desc = "dotnet restore"; Params = $null },
        @{ Name = "dnb";      Desc = "dotnet build"; Params = "[ProjectPath] opcional -> dnb ./src/MyProj" },
        @{ Name = "dnc";      Desc = "dotnet clean"; Params = $null },
        @{ Name = "dnc+";     Desc = "Eliminar carpetas bin/obj recursivamente"; Params = $null },
        @{ Name = "dnr";      Desc = "dotnet run"; Params = "[ProjectPath] opcional -> dnr ./src/MyProj" },
        @{ Name = "dnt";      Desc = "dotnet test"; Params = $null },
        @{ Name = "dn-updt";  Desc = "Listar paquetes NuGet desactualizados"; Params = "[ProjectPath] opcional -> dn-updates ./MiProyecto" }
        @{ Name = "dnv";      Desc = "Mostrar version de .NET"; Params = $null },
        @{ Name = "dn-purge"; Desc = "Matar procesos dotnet activos"; Params = $null },
        @{ Name = "dnf";      Desc = "Formatear Csharpier"; Params = $null }
        @{ Name = "dn-help";  Desc = "Mostrar esta ayuda"; Params = $null }
    )

    foreach ($cmd in $commands) {
        Write-Host ("  {0,-10} {1}" -f $cmd.Name, $cmd.Desc) -ForegroundColor Green
        if ($cmd.Params) {
            Write-Host ("{0,12} {1}" -f "", $cmd.Params) -ForegroundColor Yellow
        }
    }

    Write-Host ""
}

function dnb {
    param (
        [string]$ProjectPath = $PWD
    ) 
    cls 
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    # Push-Location $ProjectPath            #UnComment to see error hanlding
    # $buildOutput = & dotnet build 2>&1    #UnComment to see error hanlding
    # $exitCode = $LASTEXITCODE             #UnComment to see error hanlding
    # Pop-Location                          #UnComment to see error hanlding
    # cls                                   #UnComment to see error hanlding
    dotnet build $ProjectPath               #Comment to see error hanlding
    $exitCode = $LASTEXITCODE               #Comment to see error hanlding

    if ($exitCode -eq 0) {
        cls                               #Comment to see error hanlding
        Write-Host ""
        Write-Host "- " -ForegroundColor White -NoNewline
        Write-Host "BUILD SUCCESS" -ForegroundColor Green -NoNewline
        Write-Host " -" -ForegroundColor White
    }
    #UnComment to see error hanlding
    # else {
    #     Write-Host "- " -ForegroundColor White -NoNewline
    #     Write-Host "BUILD FAILED" -ForegroundColor Red -NoNewline
    #     Write-Host " -" -ForegroundColor White
    #     Write-Host ""
        
    #     $errorsByProject = @{}
    #     $buildOutput | ForEach-Object {
    #         if ($_ -match "^(.+?)\((\d+),(\d+)\):\s*(error|warning)\s*(CS\d+):\s*(.*)") {
    #             $file, $line, $col, $type, $code, $msg = $matches[1], $matches[2], $matches[3], $matches[4], $matches[5], $matches[6]
    #             $msg = $msg -replace '\s*\[.+\.csproj\]\s*$', ''
                
    #             $project = ($file -split '\\' | Where-Object { $_ -match "\.csproj$" } | ForEach-Object { $_ -replace "\.csproj$", "" }) 
    #             if (-not $project) { $project = ($file -split '\\')[-2] }
                
    #             if (-not $errorsByProject[$project]) { $errorsByProject[$project] = @() }
    #             $errorsByProject[$project] += @{ File = $file; Line = $line; Col = $col; Code = $code; Message = $msg }
    #         }
    #     }
        
    #     if ($errorsByProject.Count -gt 0) {
    #         foreach ($project in $errorsByProject.Keys | Sort-Object) {
    #             $count = $errorsByProject[$project].Count
    #             Write-Host "$project" -ForegroundColor White -NoNewline
    #             Write-Host " ($count errors)" -ForegroundColor Red
    #             Write-Host ""
    #             foreach ($err in $errorsByProject[$project]) {
    #                 Write-Host "[$($err.Code)]" -NoNewline
    #                 Write-Host " $($err.Message)" -ForegroundColor DarkRed
    #                 Write-Host "$($err.File):$($err.Line):$($err.Col)"
    #                 Write-Host ""
    #             }
    #         }
    #     }
    # }
    Write-Host ""
}

function dnc {
    dotnet clean
}

function dnc+ {
    Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | ForEach-Object { 
        Write-Host -NoNewline "Deleting: " -ForegroundColor Green
        Write-Host "$($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function dnr {
    param (
        [string]$ProjectPath = $PWD
    )
    dotnet run --project $ProjectPath
}
 
function dnt { dotnet test }

function dnrs { dotnet restore }

function dnv { dotnet --version }

function dn-purge {
    $dotnetProcesses = Get-Process -Name "dotnet" -ErrorAction SilentlyContinue
    if ($dotnetProcesses) {
        $dotnetProcesses | ForEach-Object {
            Write-Host "Stopping .NET process: $($_.Id) ($($_.Path))" -ForegroundColor Yellow
            Stop-Process -Id $_.Id -Force
        }
    } else {
        Write-Host "No running .NET processes found." -ForegroundColor Cyan
    }
}

function dn-updt {
    param (
        [string]$ProjectPath
    )

    # Si no se pasa path, usa la carpeta actual
    if (-not $ProjectPath) {
        $ProjectPath = $PWD
    }

    if (-not (Test-Path $ProjectPath)) {
        Write-Host "La ruta especificada no existe: $ProjectPath" -ForegroundColor Red
        return
    }

    Write-Host "Buscando paquetes desactualizados en: $ProjectPath" -ForegroundColor Cyan
    Write-Host ""

    # Ejecuta dotnet list package con salida legible
    dotnet list $ProjectPath package --outdated
}

# CSHARPIER FORMAT

function dnf { dotnet csharpier format . }

# ASPNETCORE_ENVIRONMENT

function asp-set-devEnv {
    setx ASPNETCORE_ENVIRONMENT "Development"
    $env:ASPNETCORE_ENVIRONMENT='Development'
}

function asp-set-prodEnv {
    setx ASPNETCORE_ENVIRONMENT "Production"
    $env:ASPNETCORE_ENVIRONMENT='Production'
}

# YARN

function pws-isyarn {
    yarn
    yarn start
}

# DOCKER

function docker-purge {
    param([switch]$KeepImages)

    docker container stop $(docker container ls -aq) | Out-Null
    docker container rm $(docker container ls -aq) -f | Out-Null
    docker volume rm $(docker volume ls -q) -f | Out-Null
    if (-not $KeepImages) {
        docker image rm $(docker image ls -aq) -f | Out-Null
    }
    Write-Host "Purge completed." -ForegroundColor Green
}
