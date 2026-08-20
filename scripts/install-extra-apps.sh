#!/usr/bin/env bash
# Install apps that are not available via Homebrew (GitHub releases, etc.).
set -euo pipefail

TMPDIR_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/setup-mac-extra.XXXXXX")"
cleanup() {
  # Detach any leftover mounts under our temp dir, then remove it.
  local mp
  for mp in "${TMPDIR_ROOT}"/mnt-*; do
    [[ -d "${mp}" ]] || continue
    hdiutil detach "${mp}" -quiet 2>/dev/null || true
  done
  rm -rf "${TMPDIR_ROOT}"
}
trap cleanup EXIT

arch="$(uname -m)" # arm64 | x86_64

app_installed() {
  local app_name="$1"
  [[ -d "/Applications/${app_name}.app" ]] || [[ -d "${HOME}/Applications/${app_name}.app" ]]
}

# Install a .app from a mounted DMG volume into /Applications.
install_app_from_volume() {
  local volume="$1"
  local app_name="$2"
  local src

  src="$(find "${volume}" -maxdepth 2 -name "${app_name}.app" -type d -print -quit)"
  if [[ -z "${src}" ]]; then
    echo "error: ${app_name}.app not found in ${volume}" >&2
    return 1
  fi

  echo "    Installing ${app_name}.app → /Applications..."
  # Replace any existing copy so re-runs can upgrade.
  rm -rf "/Applications/${app_name}.app"
  ditto "${src}" "/Applications/${app_name}.app"
}

# Download a DMG from a URL, mount it, install <AppName>.app, then clean up.
install_dmg_app() {
  local app_name="$1"
  local dmg_url="$2"
  local dmg_path="${TMPDIR_ROOT}/${app_name}.dmg"
  local mount_point="${TMPDIR_ROOT}/mnt-${app_name}"

  echo "==> ${app_name}"
  if app_installed "${app_name}"; then
    echo "    Already installed — skipping."
    return 0
  fi

  echo "    Downloading..."
  curl -fsSL -o "${dmg_path}" "${dmg_url}"

  mkdir -p "${mount_point}"
  # -nobrowse hides the volume from Finder; -readonly is enough for install.
  hdiutil attach "${dmg_path}" -mountpoint "${mount_point}" -nobrowse -readonly >/dev/null

  install_app_from_volume "${mount_point}" "${app_name}"

  hdiutil detach "${mount_point}" -quiet
  rmdir "${mount_point}" 2>/dev/null || true
  rm -f "${dmg_path}"

  echo "    Done."
}

# Resolve the latest GitHub release asset URL by exact asset name.
github_latest_asset_url() {
  local repo="$1"    # owner/name
  local pattern="$2" # e.g. Buffer_Silicon.dmg
  local api="https://api.github.com/repos/${repo}/releases/latest"
  local json url

  json="$(curl -fsSL "${api}")"

  if command -v jq >/dev/null 2>&1; then
    url="$(jq -r --arg p "${pattern}" '
      .assets[] | select(.name == $p) | .browser_download_url
    ' <<<"${json}" | head -n1)"
  else
    # Fallback without jq: look for the asset name in the JSON blob.
    url="$(printf '%s' "${json}" \
      | tr ',' '\n' \
      | grep -oE "https://[^\" ]+/${pattern}" \
      | head -n1)"
  fi

  if [[ -z "${url}" || "${url}" == "null" ]]; then
    echo "error: no asset matching '${pattern}' in ${repo} latest release" >&2
    return 1
  fi
  printf '%s\n' "${url}"
}

# --- Buffer (clipboard manager) — https://github.com/samirpatil2000/Buffer ---
install_buffer() {
  local asset
  case "${arch}" in
    arm64) asset="Buffer_Silicon.dmg" ;;
    x86_64) asset="Buffer_Intel.dmg" ;;
    *)
      echo "error: unsupported architecture: ${arch}" >&2
      return 1
      ;;
  esac

  local url
  url="$(github_latest_asset_url "samirpatil2000/Buffer" "${asset}")"
  install_dmg_app "Buffer" "${url}"
}

echo "==> Installing extra apps (not in Homebrew)..."
install_buffer

echo "==> Extra apps installed."
echo "    Note: first launch of unsigned/GitHub apps may need System Settings → Privacy & Security."
