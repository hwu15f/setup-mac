#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ensure brew is on PATH in this shell
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Run scripts/install-homebrew.sh first." >&2
  exit 1
fi

echo "==> Installing Brewfile packages..."
brew update
brew bundle --file="${ROOT}/Brewfile"

echo "==> Packages installed."
