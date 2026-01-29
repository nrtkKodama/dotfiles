#!/usr/bin/env bash
#
# check_secrets.sh
# Scans the repository for potentially unencrypted secrets in tracked files.
#

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Scanning for potential unencrypted secrets..."

EXIT_CODE=0

# Define dangerous patterns or files that should generally be encrypted
declare -a DANGEROUS_FILES=(
    "id_rsa"
    "id_ed25519"
    "id_ecdsa"
    "*.pem"
    "*.key"
    "*.p12"
    ".netrc"
    "private_key"
)

# Check for files that are 'private_' but NOT 'encrypted_'
# excluding directories
UNENCRYPTED_PRIVATE=$(find home -type f -name "private_*" ! -name "encrypted_*" ! -name "*.tmpl")

if [ -n "$UNENCRYPTED_PRIVATE" ]; then
    echo -e "${YELLOW}⚠️  WARNING: The following files are marked 'private_' but are NOT encrypted:${NC}"
    echo "$UNENCRYPTED_PRIVATE"
    echo -e "   If these contain secrets, run: ${YELLOW}chezmoi add --encrypt <path>${NC}"
    echo ""
    # We don't fail here because some private files (like config structure) might not be secrets,
    # but it's a good warning.
fi

# Grep for common secret patterns in non-encrypted files
# This is a basic check.
KEYWORDS="PRIVATE KEY|API_KEY|ACCESS_TOKEN|SECRET_KEY"

# git grep returns 0 if found (which is bad for us here)
if git grep -E -I "$KEYWORDS" -- ":!scripts/check_secrets.sh" ":!docs/"; then
    echo -e "${RED}🚨 CRITICAL: Potential secrets found in the codebase (excluding docs/scripts)!${NC}"
    echo "   Please verify the matches above."
    EXIT_CODE=1
else
    echo "✅ No obvious secret patterns found in source code."
fi

exit $EXIT_CODE
