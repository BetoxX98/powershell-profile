# PowerShell Profile - Utilidades de Desarrollo

Conjunto de funciones PowerShell para agilizar tareas comunes en desarrollo con **.NET, Docker, Yarn y más**. Optimizado para Windows PowerShell 5.1+.

## 📋 Tabla de Contenidos

- [Instalación](#instalación)
- [Comandos .NET](#comandos-dotnet)
- [Comandos ASP.NET Core](#comandos-aspnet-core)
- [Comandos Docker](#comandos-docker)
- [Comandos JavaScript/Yarn](#comandos-javascriptyarn)
- [Uso Rápido](#uso-rápido)
- [Solución de Problemas](#solución-de-problemas)

---

## 🚀 Instalación

### Opción 1: Carga automática en el perfil

1. Abre PowerShell como administrador
2. Navega a `Documentos\PowerShell` (o crea la carpeta si no existe)
3. Copia `ProfileUtils.ps1` a esa ubicación
4. Edita o crea el archivo `$PROFILE` y agrega:

```powershell
# En $PROFILE
. "$PSScriptRoot\ProfileUtils.ps1"
```

5. Recarga PowerShell o ejecuta:
```powershell
. $PROFILE
```

### Opción 2: Carga manual

```powershell
. "C:\ruta\a\ProfileUtils.ps1"
```

### Verificar instalación

```powershell
dn-help
```

---

## 🔧 Comandos .NET

Todas las utilidades de .NET comienzan con `dn` para un acceso rápido.

### Compilación y Limpieza

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `dnb` | Build (compilar) | `dnb` o `dnb ./src/MiProyecto` |
| `dnc` | Clean (limpiar artifacts) | `dnc` |
| `dnc+` | Eliminar recursivamente bin/obj | `dnc+` |

**Ejemplo:**
```powershell
dnb ./src/MiProyecto    # Compila proyecto específico
dnc+                     # Limpia todas las carpetas bin/obj
```

### Ejecución y Testing

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `dnr` | Run (ejecutar) | `dnr` o `dnr ./src/MiProyecto` |
| `dnt` | Test (ejecutar tests) | `dnt` |
| `dnrs` | Restore (restaurar dependencias) | `dnrs` |

**Ejemplo:**
```powershell
dnr ./src/Api              # Ejecuta proyecto específico
dnt                        # Ejecuta todos los tests
```

### Información y Gestión

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `dnv` | Mostrar versión de .NET | `dnv` |
| `dn-updt` | Listar paquetes desactualizados | `dn-updt` o `dn-updt ./src/Proyecto` |
| `dn-purge` | Terminar procesos dotnet | `dn-purge` |
| `dnf` | Formatear código con CSharpier | `dnf` |
| `dn-help` | Mostrar esta ayuda | `dn-help` |

**Ejemplo:**
```powershell
dnv                        # Muestra: .NET 8.0.100
dn-updt ./src              # Lista paquetes desactualizados
dn-purge                   # Termina procesos stuck
dnf                        # Formatea todo el código
```

---

## 🌐 Comandos ASP.NET Core

Gestión del ambiente de ejecución para proyectos ASP.NET Core.

| Comando | Descripción |
|---------|-------------|
| `asp-set-devEnv` | Configura `ASPNETCORE_ENVIRONMENT = Development` |
| `asp-set-prodEnv` | Configura `ASPNETCORE_ENVIRONMENT = Production` |

**Ejemplo:**
```powershell
asp-set-devEnv             # Ambiente desarrollo (habilita hot reload, etc)
asp-set-prodEnv            # Ambiente producción
```

---

## 🐳 Comandos Docker

Control y gestión de contenedores Docker.

### docker-purge

Limpia todos los recursos de Docker.

```powershell
docker-purge               # Elimina todo (contenedores, volúmenes, imágenes)
docker-purge -KeepImages   # Elimina todo EXCEPTO imágenes
```

**⚠️ Advertencia:** Este comando elimina TODOS los contenedores y volúmenes. Usa con cuidado en producción.

---

## 📦 Comandos JavaScript/Yarn

| Comando | Descripción |
|---------|-------------|
| `pws-isyarn` | Instala dependencias y ejecuta `yarn start` |

**Ejemplo:**
```powershell
pws-isyarn                 # yarn install + yarn start
```

---

## 🎯 Uso Rápido

### Flujo típico de desarrollo

```powershell
# 1. Limpiar y compilar
dnc+
dnb

# 2. Verificar paquetes desactualizados
dn-updt

# 3. Ejecutar tests
dnt

# 4. Formatear código
dnf

# 5. Ejecutar la aplicación
dnr
```

### Workflow de depuración

```powershell
# Los procesos dotnet quedan atrapados
dn-purge                   # Limpia todos los procesos

# Recompila y ejecuta
dnb && dnr
```

### Gestión de ambientes

```powershell
# Cambiar a desarrollo
asp-set-devEnv
dnr

# Cambiar a producción
asp-set-prodEnv
dnb -c Release
```

---

## 🔍 Solución de Problemas

### Las funciones no están disponibles

**Problema:** `dn-help no es reconocido`

**Solución:**
1. Verifica que `ProfileUtils.ps1` esté en `Documentos\PowerShell`
2. Confirma que el archivo está cargado en `$PROFILE`
3. Ejecuta: `. $PROFILE`
4. Comprueba: `Get-Command dn-help`

### Los comandos dotnet no funcionan

**Problema:** `dotnet: command not found`

**Solución:**
1. Instala .NET SDK desde https://dotnet.microsoft.com/download
2. Reinicia PowerShell
3. Verifica: `dnv`

### Docker-purge da error de permisos

**Problema:** `Error response from daemon: permission denied`

**Solución:**
1. Ejecuta PowerShell como administrador
2. Asegúrate que Docker Desktop esté corriendo
3. Intenta nuevamente: `docker-purge`

### CSharpier no disponible

**Problema:** `dnf` da error

**Solución:**
1. Instala CSharpier: `dotnet tool install -g csharpier`
2. Intenta nuevamente: `dnf`

---

## 📝 Estructura del Archivo

El archivo está organizado en secciones claras:

```
ProfileUtils.ps1
├── Importar Utilidades Externas
├── DOTNET - Funciones de Ayuda
├── DOTNET - Build y Clean
├── DOTNET - Ejecutar y Testear
├── DOTNET - Información y Gestión
├── ASP.NET CORE - Configuración de Ambiente
├── YARN - Gestión de dependencias
├── DOCKER - Gestión de contenedores
└── Exportar Funciones
```

Cada función incluye documentación en formato PSDoc.

---

## 💡 Mejoras Implementadas

✅ Organización en secciones temáticas  
✅ Documentación PSDoc para cada función  
✅ Validación de rutas con `Test-Path`  
✅ Mensajes de error claros y consistentes  
✅ Retroalimentación visual mejorada  
✅ Soporte para parámetros opcionales  
✅ Exportación explícita de funciones  
✅ Manejo de errores robusto  

---

## 🤝 Contribuciones

Si encuentras bugs o tienes sugerencias de mejora, siéntete libre de crear un PR o issue.

---

## 📄 Licencia

Estos scripts están disponibles bajo licencia MIT. Úsalos libremente en tus proyectos.

---

## 🔗 Referencias

- [Documentación de Dotnet CLI](https://docs.microsoft.com/es-es/dotnet/core/tools/)
- [ASP.NET Core Environment](https://docs.microsoft.com/es-es/aspnet/core/fundamentals/environments)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [PowerShell Documentation](https://docs.microsoft.com/es-es/powershell/)