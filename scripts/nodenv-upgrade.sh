#!/usr/bin/env bash
# nodenv-upgrade.sh
# Helper script to install a new Node version via nodenv and carry over global packages

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if nodenv is installed
if ! command -v nodenv &> /dev/null; then
    echo -e "${RED}Error: nodenv is not installed or not in PATH${NC}"
    exit 1
fi

# Get current Node version
CURRENT_VERSION=$(nodenv version-name)
echo -e "${BLUE}Current Node version: ${CURRENT_VERSION}${NC}"

# Save current global packages to a temporary file
PACKAGE_FILE="/tmp/nodenv-packages-${CURRENT_VERSION}.txt"
echo -e "${YELLOW}Saving current global packages to ${PACKAGE_FILE}...${NC}"

# Get list of globally installed packages, excluding npm and corepack (which come with Node)
npm list -g --depth=0 --parseable 2>/dev/null | \
    tail -n +2 | \
    xargs -n1 basename | \
    grep -v '^npm@' | \
    grep -v '^corepack@' > "$PACKAGE_FILE"

PACKAGE_COUNT=$(wc -l < "$PACKAGE_FILE" | tr -d ' ')
echo -e "${GREEN}Saved ${PACKAGE_COUNT} packages${NC}"

if [ "$PACKAGE_COUNT" -gt 0 ]; then
    echo -e "\nPackages to reinstall:"
    cat "$PACKAGE_FILE" | sed 's/^/  - /'
fi

# Show available Node versions (last 20)
echo -e "\n${BLUE}Available Node versions (showing last 20):${NC}"
nodenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -20

# Prompt for new version
echo -e "\n${YELLOW}Enter the Node version to install:${NC}"
read -p "> " NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    echo -e "${RED}Error: No version specified${NC}"
    exit 1
fi

# Check if version is already installed
if nodenv versions --bare | grep -q "^${NEW_VERSION}$"; then
    echo -e "${YELLOW}Node ${NEW_VERSION} is already installed${NC}"
    read -p "Continue anyway to reinstall packages? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
else
    # Install new Node version
    echo -e "\n${BLUE}Installing Node ${NEW_VERSION}...${NC}"
    nodenv install "$NEW_VERSION"
fi

# Switch to new version
echo -e "\n${BLUE}Switching to Node ${NEW_VERSION}...${NC}"
nodenv global "$NEW_VERSION"
nodenv rehash

# Verify switch
NEW_CURRENT=$(nodenv version-name)
echo -e "${GREEN}Now using Node ${NEW_CURRENT}${NC}"

# Reinstall packages if any
if [ "$PACKAGE_COUNT" -gt 0 ]; then
    echo -e "\n${BLUE}Reinstalling global packages...${NC}"
    while IFS= read -r package; do
        echo -e "  ${YELLOW}Installing ${package}...${NC}"
        npm install -g "$package"
    done < "$PACKAGE_FILE"

    echo -e "\n${GREEN}✓ All packages reinstalled successfully${NC}"
else
    echo -e "\n${YELLOW}No packages to reinstall${NC}"
fi

echo -e "\n${GREEN}✓ Node upgrade complete!${NC}"
echo -e "  Old version: ${CURRENT_VERSION}"
echo -e "  New version: ${NEW_CURRENT}"
echo -e "\nPackage backup saved at: ${PACKAGE_FILE}"
