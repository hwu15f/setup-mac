#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up shell..."

# Ensure Homebrew is available
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install Oh My Zsh if missing (non-interactive)
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> Oh My Zsh already installed."
fi

# fzf keybindings / completion (if fzf is installed)
if command -v fzf >/dev/null 2>&1 && [[ -d "$(brew --prefix)/opt/fzf" ]]; then
  if [[ ! -f "${HOME}/.fzf.zsh" ]]; then
    echo "==> Installing fzf shell integration..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
  fi
fi

# Default shell to zsh if it isn't already
if [[ "${SHELL}" != *zsh ]]; then
  if command -v zsh >/dev/null 2>&1; then
    echo "==> Tip: run 'chsh -s $(command -v zsh)' to make zsh your login shell."
  fi
fi

echo "==> Shell setup complete."
echo "    Add personal aliases/plugins to ~/.zshrc (keep secrets out of this repo)."
