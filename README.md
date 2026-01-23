# PowerShell Profile - Development Utilities

PowerShell function set to speed up common development tasks with **.NET, Docker, Yarn and more**. Optimized for Windows PowerShell 5.1+.

## Table of Contents

- [Installation](#installation)
- [.NET Commands](#net-commands)
- [ASP.NET Core Commands](#aspnet-core-commands)
- [Docker Commands](#docker-commands)
- [JavaScript/Yarn Commands](#javascriptyarn-commands)
- [Quick Usage](#quick-usage)
- [Troubleshooting](#troubleshooting)

---

## Installation

### Option 1: Auto-load in profile

1. Open PowerShell as administrator
2. Navigate to `Documents\PowerShell` (or create the folder if it does not exist)
3. Copy `ProfileUtils.ps1` to that location
4. Edit or create the `$PROFILE` file and add:

```powershell
# In $PROFILE
. "$PSScriptRoot\ProfileUtils.ps1"
```

5. Reload PowerShell or execute:
```powershell
. $PROFILE
```

### Option 2: Manual load

```powershell
. "C:\path\to\ProfileUtils.ps1"
```

### Verify installation

```powershell
dn-help
```

---

## .NET Commands

All .NET utilities start with `dn` for quick access.

### Build and Clean

| Command | Description | Example |
|---------|-------------|---------|
| `dnb` | Build (compile) | `dnb` or `dnb ./src/MyProject` |
| `dnc` | Clean (clean artifacts) | `dnc` |
| `dnc+` | Delete bin/obj folders recursively | `dnc+` |

**Example:**
```powershell
dnb ./src/MyProject    # Compiles specific project
dnc+                   # Cleans all bin/obj folders
```

### Run and Test

| Command | Description | Example |
|---------|-------------|---------|
| `dnr` | Run (execute) | `dnr` or `dnr ./src/MyProject` |
| `dnt` | Test (run tests) | `dnt` |
| `dnrs` | Restore (restore dependencies) | `dnrs` |

**Example:**
```powershell
dnr ./src/Api          # Runs specific project
dnt                    # Runs all tests
```

### Information and Management

| Command | Description | Example |
|---------|-------------|---------|
| `dnv` | Show .NET version | `dnv` |
| `dn-updt` | List outdated packages | `dn-updt` or `dn-updt ./src/Project` |
| `dn-purge` | Kill dotnet processes | `dn-purge` |
| `dnf` | Format code with CSharpier | `dnf` |
| `dn-help` | Show this help | `dn-help` |

**Example:**
```powershell
dnv                    # Shows: .NET 8.0.100
dn-updt ./src          # Lists outdated packages
dn-purge               # Kills stuck processes
dnf                    # Formats all code
```

---

## ASP.NET Core Commands

Manage the execution environment for ASP.NET Core projects.

| Command | Description |
|---------|-------------|
| `asp-set-devEnv` | Sets `ASPNETCORE_ENVIRONMENT = Development` |
| `asp-set-prodEnv` | Sets `ASPNETCORE_ENVIRONMENT = Production` |

**Example:**
```powershell
asp-set-devEnv        # Development environment (enables hot reload, etc)
asp-set-prodEnv       # Production environment
```

---

## Docker Commands

Control and management of Docker containers.

### docker-purge

Cleans all Docker resources.

```powershell
docker-purge           # Removes everything (containers, volumes, images)
docker-purge -KeepImages   # Removes everything EXCEPT images
```

**Warning:** This command removes ALL containers and volumes. Use carefully in production.

---

## JavaScript/Yarn Commands

| Command | Description |
|---------|-------------|
| `pws-isyarn` | Installs dependencies and runs `yarn start` |

**Example:**
```powershell
pws-isyarn            # yarn install + yarn start
```

---

## Quick Usage

### Typical development flow

```powershell
# 1. Clean and build
dnc+
dnb

# 2. Check for outdated packages
dn-updt

# 3. Run tests
dnt

# 4. Format code
dnf

# 5. Run the application
dnr
```

### Debug workflow

```powershell
# Dotnet processes get stuck
dn-purge               # Cleans all processes

# Rebuild and run
dnb && dnr
```

### Environment management

```powershell
# Switch to development
asp-set-devEnv
dnr

# Switch to production
asp-set-prodEnv
dnb -c Release
```

---

## Troubleshooting

### Functions are not available

**Problem:** `dn-help is not recognized`

**Solution:**
1. Verify that `ProfileUtils.ps1` is in `Documents\PowerShell`
2. Confirm that the file is loaded in `$PROFILE`
3. Execute: `. $PROFILE`
4. Check: `Get-Command dn-help`

### Dotnet commands do not work

**Problem:** `dotnet: command not found`

**Solution:**
1. Install .NET SDK from https://dotnet.microsoft.com/download
2. Restart PowerShell
3. Verify: `dnv`

### Docker-purge gives permission error

**Problem:** `Error response from daemon: permission denied`

**Solution:**
1. Run PowerShell as administrator
2. Make sure Docker Desktop is running
3. Try again: `docker-purge`

### CSharpier not available

**Problem:** `dnf` gives error

**Solution:**
1. Install CSharpier: `dotnet tool install -g csharpier`
2. Try again: `dnf`

---

## File Structure

The file is organized in clear sections:

```
ProfileUtils.ps1
├── Import External Utilities
├── DOTNET - Help functions
├── DOTNET - Build and Clean
├── DOTNET - Run and Test
├── DOTNET - Information and Management
├── ASP.NET CORE - Environment Configuration
├── YARN - JavaScript dependency management
├── DOCKER - Container management
└── Export Functions
```

Each function includes PSDoc format documentation.

---

## Implemented Improvements

Organized sections  
PSDoc documentation for each function  
Path validation with `Test-Path`  
Clear and consistent error messages  
Improved visual feedback  
Support for optional parameters  
Explicit function export  
Robust error handling  

---

## Contributions

If you find bugs or have improvement suggestions, feel free to create a PR or issue.

---

## License

These scripts are available under MIT license. Use them freely in your projects.

---

## References

- [Dotnet CLI Documentation](https://docs.microsoft.com/dotnet/core/tools/)
- [ASP.NET Core Environment](https://docs.microsoft.com/aspnet/core/fundamentals/environments)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)