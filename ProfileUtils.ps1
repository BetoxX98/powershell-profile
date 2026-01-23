<#
.SYNOPSIS
    PowerShell Profile Utilities - Utilidades para desarrollo .NET, Docker y más.

.DESCRIPTION
    Conjunto de funciones para acelerar tareas comunes en desarrollo.
    Incluye utilidades para dotnet, ASP.NET Core, Yarn y Docker.

.AUTHOR
    Tu Nombre

.VERSION
    1.0.0
#>

# ========================================
# DOTNET - Funciones de ayuda
# ========================================

<#
.SYNOPSIS
    Muestra ayuda con los comandos disponibles de .NET.

.DESCRIPTION
    Imprime una lista formatada de todos los comandos disponibles con su descripción y parámetros opcionales.

.EXAMPLE
    dn-help
#>
function dn-help {
    Write-Host "`nDOTNET helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "dnrs";     Desc = "dotnet restore"; Params = $null },
        @{ Name = "dnb";      Desc = "dotnet build"; Params = "[ProjectPath] opcional -> dnb ./src/MyProj" },
        @{ Name = "dnc";      Desc = "dotnet clean"; Params = $null },
        @{ Name = "dnc+";     Desc = "Eliminar carpetas bin/obj recursivamente"; Params = $null },
        @{ Name = "dnr";      Desc = "dotnet run"; Params = "[ProjectPath] opcional -> dnr ./src/MyProj" },
        @{ Name = "dnt";      Desc = "dotnet test"; Params = $null },
        @{ Name = "dn-updt";  Desc = "Listar paquetes NuGet desactualizados"; Params = "[ProjectPath] opcional -> dn-updates ./MiProyecto" },
        @{ Name = "dnv";      Desc = "Mostrar version de .NET"; Params = $null },
        @{ Name = "dn-purge"; Desc = "Terminar procesos dotnet activos"; Params = $null },
        @{ Name = "dnf";      Desc = "Formatear código con CSharpier"; Params = $null },
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

# ========================================
# DOTNET - Build y Clean
# ========================================

<#
.SYNOPSIS
    Compila un proyecto o solución .NET.

.DESCRIPTION
    Ejecuta 'dotnet build' con validación y feedback visual de éxito/error.

.PARAMETER ProjectPath
    Ruta del proyecto a compilar. Por defecto es el directorio actual.

.EXAMPLE
    dnb
    dnb ./src/MyProject
#>
function dnb {
    param (
        [string]$ProjectPath = $PWD
    )
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Error: La ruta no existe: $ProjectPath" -ForegroundColor Red
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
    Limpia los artifacts de construcción.

.DESCRIPTION
    Ejecuta 'dotnet clean' en el proyecto actual.

.EXAMPLE
    dnc
#>
function dnc {
    dotnet clean
}

<#
.SYNOPSIS
    Elimina recursivamente carpetas bin y obj.

.DESCRIPTION
    Busca y elimina todas las carpetas bin y obj en el árbol de directorios actual.
    Útil para limpiar proyectos profundamente.

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
# DOTNET - Ejecutar y Testear
# ========================================

<#
.SYNOPSIS
    Ejecuta un proyecto .NET.

.DESCRIPTION
    Ejecuta 'dotnet run' en el proyecto especificado o en el actual.

.PARAMETER ProjectPath
    Ruta del proyecto a ejecutar. Por defecto es el directorio actual.

.EXAMPLE
    dnr
    dnr ./src/MyProject
#>
function dnr {
    param (
        [string]$ProjectPath = $PWD
    )
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Error: La ruta no existe: $ProjectPath" -ForegroundColor Red
        return
    }
    
    dotnet run --project $ProjectPath
}

<#
.SYNOPSIS
    Ejecuta los tests de un proyecto.

.DESCRIPTION
    Ejecuta 'dotnet test' en el proyecto actual.

.EXAMPLE
    dnt
#>
function dnt {
    dotnet test
}

<#
.SYNOPSIS
    Restaura las dependencias NuGet.

.DESCRIPTION
    Ejecuta 'dotnet restore' en el proyecto actual.

.EXAMPLE
    dnrs
#>
function dnrs {
    dotnet restore
}

# ========================================
# DOTNET - Información y Gestión
# ========================================

<#
.SYNOPSIS
    Muestra la versión de .NET instalada.

.DESCRIPTION
    Ejecuta 'dotnet --version' para mostrar la versión del SDK instalado.

.EXAMPLE
    dnv
#>
function dnv {
    dotnet --version
}

<#
.SYNOPSIS
    Termina todos los procesos dotnet activos.

.DESCRIPTION
    Encuentra y termina todos los procesos de dotnet en ejecución.
    Útil para liberar recursos cuando hay procesos atrapados.

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
        Write-Host "Procesos .NET terminados." -ForegroundColor Green
    }
    else {
        Write-Host "No se encontraron procesos .NET en ejecución." -ForegroundColor Cyan
    }
}

<#
.SYNOPSIS
    Lista los paquetes NuGet desactualizados.

.DESCRIPTION
    Muestra un listado de paquetes NuGet que tienen versiones más nuevas disponibles.

.PARAMETER ProjectPath
    Ruta del proyecto a analizar. Por defecto es el directorio actual.

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
        Write-Host "Error: La ruta especificada no existe: $ProjectPath" -ForegroundColor Red
        return
    }

    Write-Host "Buscando paquetes desactualizados en: $ProjectPath" -ForegroundColor Cyan
    Write-Host ""

    dotnet list $ProjectPath package --outdated
}

<#
.SYNOPSIS
    Formatea el código C# con CSharpier.

.DESCRIPTION
    Ejecuta CSharpier para formatear automáticamente todo el código C# en el proyecto actual.

.EXAMPLE
    dnf
#>
function dnf {
    dotnet csharpier format .
}

# ========================================
# ASP.NET CORE - Configuración de Ambiente
# ========================================

<#
.SYNOPSIS
    Establece el ambiente a Desarrollo.

.DESCRIPTION
    Configura la variable de entorno ASPNETCORE_ENVIRONMENT a 'Development'.
    Se establece tanto en la sesión actual como de manera persistente.

.EXAMPLE
    asp-set-devEnv
#>
function asp-set-devEnv {
    setx ASPNETCORE_ENVIRONMENT "Development"
    $env:ASPNETCORE_ENVIRONMENT = 'Development'
    Write-Host "ASPNETCORE_ENVIRONMENT configurado a: Development" -ForegroundColor Green
}

<#
.SYNOPSIS
    Establece el ambiente a Producción.

.DESCRIPTION
    Configura la variable de entorno ASPNETCORE_ENVIRONMENT a 'Production'.
    Se establece tanto en la sesión actual como de manera persistente.

.EXAMPLE
    asp-set-prodEnv
#>
function asp-set-prodEnv {
    setx ASPNETCORE_ENVIRONMENT "Production"
    $env:ASPNETCORE_ENVIRONMENT = 'Production'
    Write-Host "ASPNETCORE_ENVIRONMENT configurado a: Production" -ForegroundColor Green
}

# ========================================
# YARN - Gestión de dependencias JavaScript
# ========================================

<#
.SYNOPSIS
    Inicializa e inicia un proyecto Yarn.

.DESCRIPTION
    Ejecuta 'yarn' para instalar dependencias y luego 'yarn start' para iniciar el proyecto.

.EXAMPLE
    pws-isyarn
#>
function pws-isyarn {
    yarn
    yarn start
}

# ========================================
# DOCKER - Gestión de contenedores
# ========================================

<#
.SYNOPSIS
    Purga todos los recursos de Docker.

.DESCRIPTION
    Detiene y elimina todos los contenedores, volúmenes e imágenes de Docker.
    Opcional: mantener imágenes con el switch -KeepImages.

.PARAMETER KeepImages
    Si se especifica, las imágenes de Docker no se eliminarán.

.EXAMPLE
    docker-purge
    docker-purge -KeepImages
#>
function docker-purge {
    param([switch]$KeepImages)

    Write-Host "Deteniendo contenedores de Docker..." -ForegroundColor Cyan
    docker container stop $(docker container ls -aq) | Out-Null
    
    Write-Host "Eliminando contenedores..." -ForegroundColor Cyan
    docker container rm $(docker container ls -aq) -f | Out-Null
    
    Write-Host "Eliminando volúmenes..." -ForegroundColor Cyan
    docker volume rm $(docker volume ls -q) -f | Out-Null
    
    if (-not $KeepImages) {
        Write-Host "Eliminando imágenes..." -ForegroundColor Cyan
        docker image rm $(docker image ls -aq) -f | Out-Null
    }
    
    Write-Host "Purge completado." -ForegroundColor Green
}
