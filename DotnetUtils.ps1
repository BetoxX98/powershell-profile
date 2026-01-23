# ========================================
# Dotnet Utility Functions
# ========================================

<#
.SYNOPSIS
    Ejecuta dotnet clean en el directorio actual
.DESCRIPTION
    Atajo rápido para limpiar la solución/proyecto actual
.EXAMPLE
    dnc
#>
function dnc {
    dotnet clean
}

<#
.SYNOPSIS
    Limpieza profunda de carpetas bin y obj
.DESCRIPTION
    Busca recursivamente todas las carpetas bin y obj y las elimina completamente
.EXAMPLE
    dnc+
#>
function dnc+ {
    Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | ForEach-Object { 
        Write-Host -NoNewline "Deleting: " -ForegroundColor Green
        Write-Host "$($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Exportar las funciones para que estén disponibles
Export-ModuleMember -Function dnc, 'dnc+'
