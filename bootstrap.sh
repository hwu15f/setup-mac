#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> setup-mac bootstrap"
echo "    repo: ${ROOT}"
echo

"${ROOT}/scripts/install-homebrew.sh"
"${ROOT}/scripts/install-packages.sh"
"${ROOT}/scripts/macos-defaults.sh"
"${ROOT}/scripts/setup-shell.sh"

echo
echo "==> Done. Open a new terminal (or run: exec zsh) so PATH changes take effect."
echo "    Review scripts/macos-defaults.sh and reboot if Dock/Finder settings look stale."
