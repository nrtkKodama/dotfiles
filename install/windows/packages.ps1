# Basic package installation for Windows
# Uses winget
$ErrorActionPreference = 'Stop'

Write-Host "Installing Windows packages..."

# List of packages to install
# equivalents to common tools used in dotfiles
$packages = @(
    "Starship.Starship",
    "Git.Git",
    "BurntSushi.ripgrep.MSVC",
    "sharkdp.fd",
    "eza-community.eza",
    "rossmacarthur.sheldon",
    "Jqlang.jq"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..."
    # Check if installed (simple check, winget list isn't perfect but sufficient for now or just run install which is idempotent-ish)
    # winget install will update or install.
    winget install --id $pkg -e --silent --accept-package-agreements --accept-source-agreements
}
