#!/bin/bash

# Exit on any error
set -e

CASK_FILE=${1:-"Casks/codex-intel.rb"}
CASK_TOKEN=$(basename "$CASK_FILE" .rb)
APP_NAME=${2:-"Codex.app"}

echo "Running tests for $CASK_FILE (token: $CASK_TOKEN)..."

# Cleanup function to run on exit, ensuring no state is left behind
cleanup() {
    if brew list --cask "$CASK_TOKEN" &>/dev/null; then
        echo "Cleanup: uninstalling $CASK_TOKEN..."
        brew uninstall --cask "$CASK_TOKEN" || true
    fi
    if [ -d "/Applications/$APP_NAME" ]; then
        echo "Cleanup: removing /Applications/$APP_NAME..."
        rm -rf "/Applications/$APP_NAME" || true
    fi
    if [ -d "$HOME/Applications/$APP_NAME" ]; then
        echo "Cleanup: removing ~/Applications/$APP_NAME..."
        rm -rf "$HOME/Applications/$APP_NAME" || true
    fi
}
trap cleanup EXIT

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
if ! brew uninstall --cask "$CASK_TOKEN"; then
    echo "Uninstall failed"
    exit 1
fi

# Verify uninstallation was successful
if [ -d "/Applications/$APP_NAME" ] || [ -d "$HOME/Applications/$APP_NAME" ]; then
    echo "Uninstall failed: $APP_NAME still exists."
    exit 1
else
    echo "Uninstallation verified."
fi

echo "[4/4] All tests passed successfully!"
