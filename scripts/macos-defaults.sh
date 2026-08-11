#!/usr/bin/env bash
set -euo pipefail

# Sensible macOS defaults. Comment out anything you don't want.
# Many changes need a logout/reboot or restart of Finder/Dock to fully apply.

echo "==> Applying macOS defaults..."

# --- Finder ---
# Show the path breadcrumb bar at the bottom of Finder windows
defaults write com.apple.finder ShowPathbar -bool true
# Show the status bar (item count, disk free space)
defaults write com.apple.finder ShowStatusBar -bool true
# Default Finder view: list ("Nlsv"); alternatives: icnv (icons), clmv (columns), Flwv (gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Always show file extensions (e.g. .txt, .png)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Don't warn when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Un-hide ~/Library in Finder (hidden by default)
chflags nohidden ~/Library 2>/dev/null || true

# --- Dock ---
# Dock icon size in pixels
defaults write com.apple.dock tilesize -int 42
# Minimize windows into their app's Dock icon (instead of a separate tile)
defaults write com.apple.dock minimize-to-application -bool true
# Hide the recent-apps section in the Dock
defaults write com.apple.dock show-recents -bool false
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# --- Keyboard / input ---
# Key-repeat rate when holding a key (lower = faster; range ~1–120)
defaults write NSGlobalDomain KeyRepeat -int 2
# Delay before key repeat starts (lower = shorter; range ~15–120)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable accent-character popup on key hold so holding a key repeats it (useful for Vim, etc.)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# --- Screenshots ---
# Save screenshots to a dedicated folder instead of the Desktop
mkdir -p "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
# Screenshot image format (png, jpg, pdf, tiff, etc.)
defaults write com.apple.screencapture type -string "png"
# Omit the soft drop shadow around window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# --- Mission Control / Spaces ---
# Keep Spaces in a fixed order (don't rearrange by most recently used)
defaults write com.apple.dock mru-spaces -bool false

# --- Trackpad ---
# Applied to both built-in and Bluetooth (Magic) trackpads so they stay in sync.
# Tap with one finger to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Click or tap in bottom-right (or two-finger click) for secondary click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# Enable Force Click / haptic feedback
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
# Three-finger drag to move windows (and select text)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
# Disable three-finger swipes so they don't conflict with three-finger drag
# (Mission Control / App Exposé / Spaces use four-finger swipes instead)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
# Disable three-finger tap (Look up & data detectors)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
# Two-finger double-tap for smart zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1
# Two-finger swipe from right edge for Notification Center
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
# Four-finger horizontal swipe to switch Spaces / full-screen apps
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
# Four-finger vertical swipe for Mission Control / App Exposé
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
# Pinch with thumb and three/four fingers for Launchpad / Show Desktop
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2
# Pinch to zoom and rotate with two fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true
# Natural scrolling with momentum
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -bool true

# Restart affected apps so changes take effect immediately
killall Finder Dock SystemUIServer 2>/dev/null || true

echo "==> macOS defaults applied."
