#!/usr/bin/env bash
set -euo pipefail

# Sensible macOS defaults. Comment out anything you don't want.
# Many changes need a logout/reboot or restart of Finder/Dock to fully apply.

echo "==> Applying macOS defaults..."

# --- Finder ---
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Show Library folder
chflags nohidden ~/Library 2>/dev/null || true

# --- Dock ---
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
# defaults write com.apple.dock autohide -bool true

# --- Keyboard / input ---
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# --- Screenshots ---
mkdir -p "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# --- Mission Control / Spaces ---
defaults write com.apple.dock mru-spaces -bool false

# --- Trackpad (optional) ---
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Restart affected apps
killall Finder Dock SystemUIServer 2>/dev/null || true

echo "==> macOS defaults applied."
