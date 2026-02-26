<#
.SYNOPSIS
    GitUtils - Git workflow utilities.

.DESCRIPTION
    Functions to inspect and manage local/remote git branches,
    including status relative to master/main.

.VERSION
    1.3.0
#>

# ========================================
# GIT - Help
# ========================================

function git-help {
    Write-Host "`nGIT helper commands:`n" -ForegroundColor Cyan

    $commands = @(
        @{ Name = "git-branches"; Desc = "List all local branches with status and owner"; Params = "[-base <branch>] branch to compare (default: master/main) | [-fetch] fetch before listing" },
        @{ Name = "git-clean";    Desc = "Delete merged local-only branches owned by you"; Params = "[-base <branch>] branch to check against (default: master/main) | [-fetch] fetch before cleaning" },
        @{ Name = "git-help";     Desc = "Show this help"; Params = $null }
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
# GIT - Shared helpers
# ========================================

function _git-assert-repo {
    $null = git rev-parse --is-inside-work-tree 2>$null
    return $LASTEXITCODE -eq 0
}

function _git-resolve-base {
    param([string]$base, [string[]]$localBranches)

    if ($base) { return $base }
    if ($localBranches -contains "main")   { return "main" }
    if ($localBranches -contains "master") { return "master" }
    return $null
}

function _git-collect-data {
    # Returns a hashtable with:
    #   LocalBranches   : string[]
    #   RemoteSet       : HashSet of branch names actually present in origin
    #   AuthorMap       : branch -> author name of tip commit
    #   CurrentBranch   : string

    # Force UTF-8 so git outputs names with accents/special chars correctly
    $prevEncoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    $refData = git -c core.quotepath=false for-each-ref --format "%(refname:short)|%(authorname)" refs/heads/ 2>$null

    $authorMap        = @{}
    $allLocalBranches = [System.Collections.Generic.List[string]]::new()

    foreach ($line in $refData) {
        $parts = $line -split "\|", 2
        $b     = $parts[0]
        $author = if ($parts.Count -gt 1) { $parts[1] } else { "" }
        $authorMap[$b] = $author
        $allLocalBranches.Add($b)
    }

    # Actual remote refs — only branches that truly exist on origin right now
    $remoteSet = [System.Collections.Generic.HashSet[string]]::new()
    git -c core.quotepath=false for-each-ref --format "%(refname:short)" refs/remotes/origin/ 2>$null |
        Where-Object { $_ -notmatch "/HEAD$" } |
        ForEach-Object { $null = $remoteSet.Add(($_ -replace "^origin/", "")) }

    $currentBranch = git rev-parse --abbrev-ref HEAD 2>$null

    [Console]::OutputEncoding = $prevEncoding

    return @{
        LocalBranches  = $allLocalBranches.ToArray()
        RemoteSet      = $remoteSet
        AuthorMap      = $authorMap
        CurrentBranch  = $currentBranch
    }
}

# ========================================
# GIT - Branch inspector
# ========================================

function git-branches {
    param(
        [string]$base  = "",
        [switch]$fetch
    )

    if (-not (_git-assert-repo)) {
        Write-Host "Not inside a git repository." -ForegroundColor Red
        return
    }

    if ($fetch) {
        Write-Host "Fetching..." -ForegroundColor DarkGray
        git fetch --quiet 2>$null
    }

    $data = _git-collect-data
    $allLocalBranches = $data.LocalBranches
    $remoteSet        = $data.RemoteSet
    $authorMap        = $data.AuthorMap
    $currentBranch    = $data.CurrentBranch

    $base = _git-resolve-base -base $base -localBranches $allLocalBranches
    if (-not $base) {
        Write-Host "Could not detect a base branch (master/main). Use -base <branch>." -ForegroundColor Red
        return
    }

    # ahead/behind per branch vs base (1 git call per branch)
    $diffMap = @{}
    foreach ($b in $allLocalBranches) {
        if ($b -eq $base) { continue }
        $counts = git rev-list --left-right --count "$base...$b" 2>$null
        if ($counts -match "^(\d+)\s+(\d+)$") {
            $diffMap[$b] = @{ Behind = [int]$Matches[1]; Ahead = [int]$Matches[2] }
        } else {
            $diffMap[$b] = @{ Behind = 0; Ahead = 0 }
        }
    }

    # Column widths
    $currentSuffix = " (current)"
    $maxBranch = ($allLocalBranches | Measure-Object -Property Length -Maximum).Maximum
    $maxAuthor = ($authorMap.Values   | Measure-Object -Property Length -Maximum).Maximum
    $branchCol = [Math]::Max($maxBranch + 2, 20)
    $authorCol = [Math]::Max($maxAuthor + 1, 12)
    # statusCol must fit "local only (current)" = 20 chars + 1 space
    $statusCol = 21
    $sepWidth  = $branchCol + $authorCol + $statusCol + 14

    Write-Host ""
    Write-Host ("  {0,-$branchCol} {1,-$authorCol} {2,-$statusCol} {3}" -f "Branch", "Owner", "Status", "vs $base") -ForegroundColor DarkGray
    Write-Host ("  {0}" -f ("-" * $sepWidth)) -ForegroundColor DarkGray

    foreach ($branch in $allLocalBranches) {

        # Base location (remote / local only) — independent of current
        if ($remoteSet.Contains($branch)) {
            $location      = "remote"
            $locationColor = "Green"
        } else {
            $location      = "local only"
            $locationColor = "Yellow"
        }
        $isCurrent = ($branch -eq $currentBranch)

        # Diff vs base
        if ($branch -eq $base) {
            $diffStatus = "(base)"
            $diffColor  = "DarkGray"
        } else {
            $d = $diffMap[$branch]
            if ($d.Ahead -eq 0 -and $d.Behind -eq 0) {
                $diffStatus = "up to date"
                $diffColor  = "DarkGray"
            } else {
                $parts = @()
                if ($d.Ahead  -gt 0) { $parts += "+$($d.Ahead)" }
                if ($d.Behind -gt 0) { $parts += "-$($d.Behind)" }
                $diffStatus = $parts -join " / "
                $diffColor  = if ($d.Ahead -gt 0) { "Magenta" } else { "DarkYellow" }
            }
        }

        # Render row
        $prefix = if ($isCurrent) { "* " } else { "  " }
        $padded = $branchCol - 2
        Write-Host -NoNewline ("$prefix{0,-$padded} " -f $branch) -ForegroundColor White
        Write-Host -NoNewline ("{0,-$authorCol} " -f $authorMap[$branch]) -ForegroundColor DarkGray

        # Status column: location + optional " (current)" suffix + padding
        $suffixLen  = if ($isCurrent) { $currentSuffix.Length } else { 0 }
        $visibleLen = $location.Length + $suffixLen
        $pad        = " " * ([Math]::Max($statusCol - $visibleLen, 1))
        Write-Host -NoNewline $location -ForegroundColor $locationColor
        if ($isCurrent) { Write-Host -NoNewline $currentSuffix -ForegroundColor Cyan }
        Write-Host -NoNewline $pad

        Write-Host $diffStatus -ForegroundColor $diffColor
    }

    Write-Host ""
}

# ========================================
# GIT - Clean merged local-only branches
# ========================================

function git-clean {
    param(
        [string]$base  = "",
        [switch]$fetch
    )

    if (-not (_git-assert-repo)) {
        Write-Host "Not inside a git repository." -ForegroundColor Red
        return
    }

    if ($fetch) {
        Write-Host "Fetching..." -ForegroundColor DarkGray
        git fetch --quiet 2>$null
    }

    $data = _git-collect-data
    $allLocalBranches = $data.LocalBranches
    $remoteSet        = $data.RemoteSet
    $authorMap        = $data.AuthorMap
    $currentBranch    = $data.CurrentBranch

    $base = _git-resolve-base -base $base -localBranches $allLocalBranches
    if (-not $base) {
        Write-Host "Could not detect a base branch (master/main). Use -base <branch>." -ForegroundColor Red
        return
    }

    $me = (git config user.name 2>$null).Trim()
    if (-not $me) {
        Write-Host "  git user.name is not configured. Run: git config --global user.name 'Your Name'" -ForegroundColor Red
        return
    }

    # Branches fully merged into base (tip is ancestor of base)
    $mergedBranches = git branch --merged $base --format "%(refname:short)" 2>$null

    $candidates = $allLocalBranches | Where-Object {
        $_ -ne $base -and                        # not the base itself
        (-not $remoteSet.Contains($_)) -and      # not present on remote
        ($authorMap[$_] -eq $me) -and            # owned by current user
        ($mergedBranches -contains $_)           # fully merged into base
    }

    if (-not $candidates) {
        Write-Host ""
        Write-Host "  No branches to clean up." -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    $needsCheckout = $candidates -contains $currentBranch

    Write-Host ""
    Write-Host "  Branches to delete (local only, merged into $base, owned by you):" -ForegroundColor Cyan
    Write-Host ""
    foreach ($b in $candidates) {
        $tag = if ($b -eq $currentBranch) { " (current - will checkout $base first)" } else { "" }
        Write-Host -NoNewline "    - $b" -ForegroundColor Yellow
        if ($tag) { Write-Host $tag -ForegroundColor DarkGray } else { Write-Host "" }
    }
    Write-Host ""

    $confirm = Read-Host "  Delete these $($candidates.Count) branch(es)? [y/N]"
    if ($confirm -notmatch "^[yY]$") {
        Write-Host "  Aborted." -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    # If current branch is a candidate, switch to base first
    if ($needsCheckout) {
        Write-Host ""
        Write-Host "  Switching to $base..." -ForegroundColor DarkGray
        git checkout $base 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Could not checkout $base. Aborting." -ForegroundColor Red
            Write-Host ""
            return
        }
    }

    Write-Host ""
    foreach ($b in $candidates) {
        git branch -d $b 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Deleted: $b" -ForegroundColor Green
        } else {
            Write-Host "  Failed:  $b" -ForegroundColor Red
        }
    }
    Write-Host ""
}
