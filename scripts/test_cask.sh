#!/bin/bash

# Exit on any error
set -e

CASK_FILE=${1:-"Casks/codex-intel.rb"}
APP_NAME=${2:-"Codex.app"}

echo "Running tests for $CASK_FILE..."

# 1. Syntax Validation (brew audit)
echo "[1/4] Auditing syntax with brew..."
# Strict audit checks for syntax and basic style issues
if ! brew audit --cask --strict "$CASK_FILE"; then
    echo "Audit failed"
    exit 1
fi
echo "Audit passed."

# 2. Test Installation
echo "[2/4] Testing installation..."
if ! brew install --cask "$CASK_FILE"; then
    echo "Install failed"
    exit 1
fi

# Verify if it was installed successfully
# By default, Homebrew Casks install to /Applications or ~/Applications
if [ -d "/Applications/$APP_NAME" ]; then
    echo "Installation verified: /Applications/$APP_NAME exists."
elif [ -d "$HOME/Applications/$APP_NAME" ]; then
    echo "Installation verified: ~/Applications/$APP_NAME exists."
else
    echo "Installation failed: $APP_NAME not found in /Applications or ~/Applications"
    exit 1
fi

# 3. Test Uninstallation
echo "[3/4] Testing uninstallation..."
if ! brew uninstall --cask "$CASK_FILE"; then
    echo "Uninstall failed"
    exit 1
fi

# Verify uninstallation was successful
if [ -d "/Applications/Codex.app" ] || [ -d "$HOME/Applications/Codex.app" ]; then
    echo "Uninstall failed: Codex.app still exists."
    exit 1
else
    echo "Uninstallation verified."
fi

echo "[4/4] All tests passed successfully!"
