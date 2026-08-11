#!/usr/bin/env bash
set -euo pipefail

if command -v brew >/dev/null 2>&1; then
  echo "==> Homebrew already installed: $(brew --prefix)"
  exit 0
fi

echo "==> Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon vs Intel path
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Persist brew in shell profile for new terminals
BREW_ENV_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
if [[ -x /usr/local/bin/brew ]]; then
  BREW_ENV_LINE='eval "$(/usr/local/bin/brew shellenv)"'
fi

for profile in "${HOME}/.zprofile" "${HOME}/.bash_profile"; do
  if [[ -f "${profile}" ]] && grep -Fq 'brew shellenv' "${profile}"; then
    continue
  fi
  if [[ -f "${profile}" ]] || [[ "${profile}" == "${HOME}/.zprofile" ]]; then
    touch "${profile}"
    {
      echo ""
      echo "# Homebrew"
      echo "${BREW_ENV_LINE}"
    } >> "${profile}"
    echo "==> Added Homebrew to ${profile}"
  fi
done

echo "==> Homebrew installed."
