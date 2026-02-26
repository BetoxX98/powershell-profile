# PowerShell Profile - Development Utilities

PowerShell utility modules to speed up common development tasks with **.NET, ASP.NET Core, Docker, Yarn, Git and more**.

## File Structure

```
powershell-profile/
├── ProfileUtils.ps1          # Hub: loads all modules
└── modules/
    ├── PowerShellUtils.ps1   # Session utilities (c, open, terminal, pws-*)
    ├── DotnetUtils.ps1       # .NET commands (dnb, dnr, dnt, dnc...)
    ├── AspNetUtils.ps1       # ASP.NET Core environment
    ├── DockerUtils.ps1       # Docker container management
    ├── YarnUtils.ps1         # Yarn / JavaScript
    └── GitUtils.ps1          # Git branch inspection and cleanup
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
| `yarn-is` | `yarn install` + `yarn start` |
| `yarn-help` | Show this module's help |

---

### Git — `GitUtils.ps1`

| Command | Description | Example |
|---------|-------------|---------|
| `git-branches` | List all local branches with owner, location and divergence vs base | `git-branches` or `git-branches -base develop` |
| `git-branches -fetch` | Same but fetches from remote first | `git-branches -fetch` |
| `git-clean` | Delete local-only merged branches owned by you (with confirmation) | `git-clean` or `git-clean -base develop` |
| `git-clean -fetch` | Same but fetches from remote first | `git-clean -fetch` |
| `git-help` | Show this module's help | `git-help` |

**`git-branches` output columns:**

| Column | Values |
|--------|--------|
| Branch | Branch name (`*` marks current) |
| Owner | Author of tip commit |
| Status | `remote`, `local only`, with optional `(current)` suffix |
| vs base | `(base)`, `up to date`, `+N` ahead, `-N` behind, `+N / -N` diverged |

> **Note:** `git-clean` only deletes branches that are **fully merged** into the base, **not present on remote**, and whose tip commit **belongs to you** (`git config user.name`). It asks for confirmation before deleting. If your current branch is a candidate, it will checkout the base branch first.

---

## Help

```powershell
profile-help   # Show all modules' help at once
pws-help       # PowerShell only
dn-help        # .NET only
asp-help       # ASP.NET Core only
docker-help    # Docker only
yarn-help      # Yarn only
git-help       # Git only
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

**`git-branches` / `git-clean` show wrong remote status**
Remote-tracking refs may be stale. Run with `-fetch` to update them: `git-branches -fetch`

**`git-clean` reports "git user.name is not configured"**
Set your git identity: `git config --global user.name "Your Name"`

**`git-clean` finds no candidates despite having merged branches**
The author of the branch tip must match your `git config user.name` exactly. Check with: `git config user.name`

---

## References

- [Dotnet CLI Documentation](https://docs.microsoft.com/dotnet/core/tools/)
- [ASP.NET Core Environment](https://docs.microsoft.com/aspnet/core/fundamentals/environments)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
