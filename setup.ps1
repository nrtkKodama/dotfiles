# setup.ps1
$ErrorActionPreference = 'Stop'

# Default Configuration
$GitHubUser = "nrtkKodama"
$DotfilesRepoName = "dotfiles"
$DotfilesBranch = "main"

# Allow overriding via environment variables
if ($env:GITHUB_USER) { $GitHubUser = $env:GITHUB_USER }
if ($env:DOTFILES_REPO_NAME) { $DotfilesRepoName = $env:DOTFILES_REPO_NAME }
if ($env:DOTFILES_BRANCH) { $DotfilesBranch = $env:DOTFILES_BRANCH }

$RepoUrl = "https://github.com/$GitHubUser/$DotfilesRepoName"

# Check if running locally (e.g. cloned repo)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if (Test-Path "$ScriptDir/.git") {
    $RepoUrl = $ScriptDir
}

Write-Host "Setting up dotfiles from $RepoUrl (branch: $DotfilesBranch)..."

# Utility: Check if command exists
function Test-CommandExists {
    param ($Command)
    (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null
}

# Install chezmoi if not present
if (-not (Test-CommandExists chezmoi)) {
    Write-Host "chezmoi not found. Installing..."
    if (Test-CommandExists winget) {
        winget install twpayne.chezmoi
    } else {
        # Fallback to binary download
        $BinDir = "$env:LOCALAPPDATA\bin"
        if (-not (Test-Path $BinDir)) { New-Item -ItemType Directory -Path $BinDir | Out-Null }
        
        # Add to PATH for this session
        $env:PATH = "$BinDir;$env:PATH"
        [System.Environment]::SetEnvironmentVariable("Path", $env:PATH + ";$BinDir", [System.EnvironmentVariableTarget]::User)
        
        iex "& { $(irm https://chezmoi.io/get.ps1) } -b '$BinDir'"
    }
}

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")

if (-not (Test-CommandExists chezmoi)) {
    Write-Host "Warning: chezmoi command not found immediately after install. Installation might strictly require a new shell." -ForegroundColor Yellow
    # Try fully qualified path if we installed to local bin
    $LocalChezmoi = "$env:LOCALAPPDATA\bin\chezmoi.exe"
    if (Test-Path $LocalChezmoi) {
        Set-Alias chezmoi $LocalChezmoi
    }
}

# Init and Apply
Write-Host "Running chezmoi init..."
chezmoi init $RepoUrl --branch $DotfilesBranch --apply --force

Write-Host "Dotfiles setup complete!"
