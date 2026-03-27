# Codex Intel Homebrew Tap

[![Scheduled Build Codex App (Intel)](https://github.com/soham2008xyz/codex-intel/actions/workflows/schedule.yml/badge.svg)](https://github.com/soham2008xyz/codex-intel/actions/workflows/schedule.yml)
[![Test Homebrew Cask](https://github.com/soham2008xyz/codex-intel/actions/workflows/test.yml/badge.svg)](https://github.com/soham2008xyz/codex-intel/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/soham2008xyz/codex-intel?display_name=tag)](https://github.com/soham2008xyz/codex-intel/releases/latest)

This repository ships an unofficial Homebrew cask tap for installing Codex on Intel Macs.

Instead of manually rebuilding the app for Intel on every release, GitHub Actions now:

1. Downloads the latest official Apple Silicon Codex DMG from OpenAI.
2. Rebuilds it for Intel/AMD64 on an Intel macOS runner.
3. Publishes the converted app as a GitHub release asset.
4. Updates [`Casks/codex-intel.rb`](Casks/codex-intel.rb) so Homebrew installs that release.

The core automation lives in [`schedule.yml`](.github/workflows/schedule.yml), and cask validation runs in [`test.yml`](.github/workflows/test.yml).

## What This Tap Provides

- A custom cask token: `codex-intel`
- An Intel-compatible `Codex.app` packaged as a GitHub release asset
- A Homebrew install and upgrade path for Intel Macs
- Automated checks every 6 hours for new upstream Codex releases

## Tap Usage

Install the tap and the cask from GitHub:

```bash
brew tap soham2008xyz/codex-intel
brew install --cask codex-intel
```

Notes:

- The cask installs `Codex.app`.
- The cask conflicts with the official `codex` cask, so uninstall that first if needed.

Upgrade to the latest converted release:

```bash
brew upgrade --cask codex-intel
```

Reinstall the current cask:

```bash
brew reinstall --cask codex-intel
```

Remove the app:

```bash
brew uninstall --cask codex-intel
```

Remove the tap when you no longer need it:

```bash
brew untap soham2008xyz/codex-intel
```

## How The Automation Works

[`schedule.yml`](.github/workflows/schedule.yml) runs every 6 hours and also supports manual dispatch. The workflow:

- downloads the latest upstream `Codex.dmg`
- extracts the app version from `Info.plist`
- skips work if the matching `-intel` release already exists
- builds the Intel app with `make build`
- uploads `Codex-Intel.zip` to a GitHub release
- updates the cask version and SHA256 on the default branch

[`test.yml`](.github/workflows/test.yml) validates the tap on Intel macOS by:

- checking out the repository
- setting up Homebrew
- auditing the cask
- installing and uninstalling it via [`scripts/test_cask.sh`](scripts/test_cask.sh)

## Repository Layout

- [`Casks/codex-intel.rb`](Casks/codex-intel.rb): Homebrew cask definition
- [`scripts/build.sh`](scripts/build.sh): Intel rebuild pipeline used by CI
- [`scripts/test_cask.sh`](scripts/test_cask.sh): local and CI cask verification
- [`Makefile`](Makefile): build entrypoint used by the scheduled workflow

## Notes

- This project is unofficial and is not affiliated with OpenAI.
- The install source for the cask is this repository's GitHub release assets, not OpenAI directly.
- If macOS flags the app after install, try `xattr -cr /Applications/Codex.app` and relaunch it.
