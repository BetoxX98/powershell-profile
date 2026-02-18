# PowerShell Profile - Development Utilities

PowerShell utility modules to speed up common development tasks with **.NET, ASP.NET Core, Docker, Yarn and more**.

## File Structure

```
powershell-profile/
├── ProfileUtils.ps1          # Hub: loads all modules
└── modules/
    ├── PowerShellUtils.ps1   # Session utilities (c, open, terminal, pws-*)
    ├── DotnetUtils.ps1       # .NET commands (dnb, dnr, dnt, dnc...)
    ├── AspNetUtils.ps1       # ASP.NET Core environment
    ├── DockerUtils.ps1       # Docker container management
    └── YarnUtils.ps1         # Yarn / JavaScript
```

## Installation

Clone the repo and add to your `$PROFILE`:

```powershell
. "C:\path\to\powershell-profile\ProfileUtils.ps1"
```

To verify:

```powershell
dn-help
```

### Load only specific modules

```powershell
# Only .NET and Docker
. "C:\path\to\powershell-profile\modules\DotnetUtils.ps1"
. "C:\path\to\powershell-profile\modules\DockerUtils.ps1"
```

---

## Commands

### PowerShell — `PowerShellUtils.ps1`

| Command | Description |
|---------|-------------|
| `c` | Clear screen |
| `open` | Open current directory in Explorer |
| `terminal` | Open new Windows Terminal |
| `terminal -claude` | Open Windows Terminal with Claude CLI |
| `pws-p` | Edit `$PROFILE` in VSCode |
| `pws-s` | Reload `$PROFILE` |
| `pws-l` | List `pws-*` functions |
| `pws-help` | Show this module's help |

---

### .NET — `DotnetUtils.ps1`

| Command | Description | Example |
|---------|-------------|---------|
| `dnb` | dotnet build | `dnb` or `dnb ./src/MyProject` |
| `dnc` | dotnet clean | `dnc` |
| `dnc+` | Delete bin/obj folders recursively | `dnc+` |
| `dnr` | dotnet run | `dnr` or `dnr ./src/MyProject` |
| `dnt` | dotnet test | `dnt` |
| `dnrs` | dotnet restore | `dnrs` |
| `dnv` | Show .NET version | `dnv` |
| `dn-updt` | List outdated NuGet packages | `dn-updt` or `dn-updt ./src` |
| `dn-purge` | Kill active dotnet processes | `dn-purge` |
| `dnf` | Format code with CSharpier | `dnf` |
| `dn-help-dotnet` | Show this module's help | `dn-help-dotnet` |

---

### ASP.NET Core — `AspNetUtils.ps1`

| Command | Description |
|---------|-------------|
| `asp-set-devEnv` | Set `ASPNETCORE_ENVIRONMENT = Development` |
| `asp-set-prodEnv` | Set `ASPNETCORE_ENVIRONMENT = Production` |
| `asp-help` | Show this module's help |

---

### Docker — `DockerUtils.ps1`

| Command | Description |
|---------|-------------|
| `docker-purge` | Stop and remove all containers, volumes and images |
| `docker-purge -KeepImages` | Same but keeps images |
| `docker-help` | Show this module's help |

> **Warning:** `docker-purge` removes all local Docker resources. Use with care.

---

### Yarn — `YarnUtils.ps1`

| Command | Description |
|---------|-------------|
| `pws-isyarn` | `yarn install` + `yarn start` |
| `yarn-help` | Show this module's help |

---

## Help

```powershell
dn-help          # Show all modules' help at once
dn-help-dotnet   # .NET only
asp-help         # ASP.NET Core only
docker-help      # Docker only
yarn-help        # Yarn only
pws-help         # PowerShell only
```

---

## Troubleshooting

**Functions not available**
1. Confirm `ProfileUtils.ps1` is dot-sourced in `$PROFILE`
2. Reload: `. $PROFILE`
3. Check: `Get-Command dn-help`

**`dotnet` not found**
Install the .NET SDK: https://dotnet.microsoft.com/download

**`docker-purge` permission error**
Run PowerShell as administrator and make sure Docker Desktop is running.

**`dnf` not working**
Install CSharpier: `dotnet tool install -g csharpier`

---

## References

- [Dotnet CLI Documentation](https://docs.microsoft.com/dotnet/core/tools/)
- [ASP.NET Core Environment](https://docs.microsoft.com/aspnet/core/fundamentals/environments)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
