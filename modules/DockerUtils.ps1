<#
.SYNOPSIS
    DockerUtils - Docker container management utilities.

.DESCRIPTION
    Functions to manage Docker containers, volumes and images.

.VERSION
    1.0.0
#>

# ========================================
# DOCKER - Help
# ========================================

function docker-help {
    Write-Host "`nDOCKER helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "docker-purge"; Desc = "Stop and remove all containers, volumes and images"; Params = "[-KeepImages] keep images -> docker-purge -KeepImages" },
        @{ Name = "docker-help";  Desc = "Show this help"; Params = $null }
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
# DOCKER - Container management
# ========================================

function docker-purge {
    param([switch]$KeepImages)

    $containers = docker container ls -aq
    if ($containers) {
        Write-Host "Stopping Docker containers..." -ForegroundColor Cyan
        docker container stop $containers | Out-Null
        Write-Host "Removing containers..." -ForegroundColor Cyan
        docker container rm $containers -f | Out-Null
    } else {
        Write-Host "No containers found." -ForegroundColor DarkGray
    }

    $volumes = docker volume ls -q
    if ($volumes) {
        Write-Host "Removing volumes..." -ForegroundColor Cyan
        docker volume rm $volumes -f | Out-Null
    } else {
        Write-Host "No volumes found." -ForegroundColor DarkGray
    }

    if (-not $KeepImages) {
        $images = docker image ls -aq
        if ($images) {
            Write-Host "Removing images..." -ForegroundColor Cyan
            docker image rm $images -f | Out-Null
        } else {
            Write-Host "No images found." -ForegroundColor DarkGray
        }
    }

    Write-Host "Purge completed." -ForegroundColor Green
}
