# Gemini Project Context: Codex Intel Rebuilder & Homebrew Tap

This repository provides an automated pipeline and Homebrew tap for installing an unofficial Intel (x86_64) port of the OpenAI Codex Desktop App.

## Project Overview

- **Purpose:** Rebuilds the Apple Silicon-only Codex app for Intel Macs by replacing its Electron runtime and rebuilding architecture-specific native modules.
- **Core Technology:** 
  - **Node.js:** Powers the `rebuild_codex.js` script which handles DMG mounting, asset extraction, and app assembly.
  - **Electron:** The application framework; the rebuilder downloads the matching x64 version of Electron.
  - **Homebrew:** Used for distribution via a custom Cask.
  - **GitHub Actions:** Automates the build and release process every 6 hours.

## Key Files & Directories

- `Casks/codex-intel.rb`: The Homebrew Cask definition.
- `scripts/rebuild_codex.js`: The primary build logic.
- `scripts/build.sh`: Orchestration script for the build process (Prerequisites, Download, Rebuild, Fix Permissions).
- `scripts/test_cask.sh`: Validates the Homebrew Cask locally or in CI.
- `Makefile`: Entry point for common development tasks.
- `.github/workflows/`:
  - `schedule.yml`: Automated build, release, and Cask update.
  - `test.yml`: Continuous integration for Cask validation.

## Building and Running

### Prerequisites
- **Node.js:** Required for the rebuild script.
- **Homebrew:** Required for cask testing and usage.
- **Intel Mac (or Rosetta 2):** Necessary for building/testing the x64 binary.

### Key Commands

- **Build the Intel App:**
  ```bash
  make build
  ```
  This downloads `Codex.dmg`, extracts resources, and assembles `Codex.app`.

- **Install Locally:**
  ```bash
  make install
  ```
  Moves the built `Codex.app` to `/Applications/`.

- **Test the Homebrew Cask:**
  ```bash
  ./scripts/test_cask.sh
  ```
  Audits, installs, and uninstalls the cask to ensure it works correctly.

- **Clean Artifacts:**
  ```bash
  make clean
  ```
  Removes temporary build directories, downloaded DMGs, and cached Electron zips.

## Development Conventions

- **Native Modules:** The rebuilder explicitly handles `better-sqlite3` and `node-pty` by rebuilding them from source for the target Electron version and architecture.
- **Sandbox Fix:** The built app includes a wrapper script in `Contents/MacOS/Codex` that launches the real binary with the `--no-sandbox` flag to ensure compatibility.
- **Automation:** Version updates in `Casks/codex-intel.rb` are handled automatically by the `schedule.yml` workflow. Manual edits to the version/sha256 should only be done if the automation fails.
- **Style:** Shell scripts use `set -e` for safety. The JavaScript rebuilder uses `execSync` for synchronous operations and clear logging.
