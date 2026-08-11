#!/usr/bin/env bash
set -euo pipefail

# Pretty terminal stack (Ghostty + Starship + Catppuccin):
# https://medium.com/@yi.cheng/setting-up-the-pretty-mac-terminal-in-2026-ghostty-starship-catppuccin-0420189ad43f

echo "==> Setting up shell (Ghostty + Starship + Catppuccin)..."

# Ensure Homebrew is available
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

ensure_brew_pkg() {
  local pkg="$1"
  if ! brew list --formula "${pkg}" >/dev/null 2>&1; then
    echo "==> Installing ${pkg}..."
    brew install "${pkg}"
  fi
}

ensure_brew_cask() {
  local cask="$1"
  if ! brew list --cask "${cask}" >/dev/null 2>&1; then
    echo "==> Installing cask ${cask}..."
    brew install --cask "${cask}"
  fi
}

# Packages from the guide (also listed in Brewfile)
ensure_brew_cask ghostty
ensure_brew_cask font-jetbrains-mono-nerd-font
ensure_brew_pkg starship
ensure_brew_pkg zsh-autosuggestions
ensure_brew_pkg zsh-syntax-highlighting

# Ghostty: JetBrainsMono Nerd Font + Catppuccin Mocha
GHOSTTY_DIR="${HOME}/.config/ghostty"
GHOSTTY_CONFIG="${GHOSTTY_DIR}/config"
mkdir -p "${GHOSTTY_DIR}"
if [[ ! -f "${GHOSTTY_CONFIG}" ]]; then
  echo "==> Writing Ghostty config..."
  cat >"${GHOSTTY_CONFIG}" <<'EOF'
font-family = JetBrainsMono Nerd Font
font-size = 14
theme = Catppuccin Mocha
EOF
else
  echo "==> Ghostty config already present (${GHOSTTY_CONFIG})."
fi

# Install Oh My Zsh if missing (non-interactive)
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> Oh My Zsh already installed."
fi

# Starship + Catppuccin Powerline preset (default Starship look is minimal — don't skip)
STARSHIP_TOML="${HOME}/.config/starship.toml"
mkdir -p "${HOME}/.config"
if [[ ! -f "${STARSHIP_TOML}" ]]; then
  echo "==> Applying Starship catppuccin-powerline preset..."
  starship preset catppuccin-powerline -o "${STARSHIP_TOML}"
else
  echo "==> Starship config already present (${STARSHIP_TOML})."
fi

# Ensure ~/.zshrc exists (Oh My Zsh creates it on fresh install)
ZSHRC="${HOME}/.zshrc"
if [[ ! -f "${ZSHRC}" ]]; then
  echo "==> Creating ${ZSHRC}..."
  touch "${ZSHRC}"
fi

# Oh My Zsh theme conflicts with Starship — clear ZSH_THEME
if grep -qE '^[[:space:]]*ZSH_THEME=' "${ZSHRC}"; then
  echo "==> Clearing ZSH_THEME in ~/.zshrc (Starship owns the prompt)..."
  tmp="$(mktemp)"
  sed -E 's/^[[:space:]]*ZSH_THEME=.*/ZSH_THEME=""/' "${ZSHRC}" >"${tmp}"
  mv "${tmp}" "${ZSHRC}"
else
  echo 'ZSH_THEME=""' >>"${ZSHRC}"
fi

echo "==> Ensuring zsh plugins + Starship init in ~/.zshrc..."
if ! grep -Fq "zsh-autosuggestions.zsh" "${ZSHRC}"; then
  echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >>"${ZSHRC}"
fi
if ! grep -Fq "zsh-syntax-highlighting.zsh" "${ZSHRC}"; then
  echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>"${ZSHRC}"
fi
if ! grep -Fq 'starship init zsh' "${ZSHRC}"; then
  echo 'eval "$(starship init zsh)"' >>"${ZSHRC}"
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
echo "    Open Ghostty (quit fully with Cmd+Q if already open so font/theme apply)."
echo "    Then run: exec zsh"
echo "    Themes later: ghostty +list-themes | starship preset <name> -o ~/.config/starship.toml"
echo "    Add personal aliases/plugins to ~/.zshrc (keep secrets out of this repo)."
