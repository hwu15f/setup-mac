# setup-mac

Automate a fresh MacBook setup: Homebrew, apps, CLI tools, and sensible macOS defaults.

## Quick start

On a new Mac (or to re-run on an existing one):

```bash
git clone <your-repo-url> ~/Projects/setup-mac
cd ~/Projects/setup-mac
chmod +x bootstrap.sh
./bootstrap.sh
```

Or run one step at a time:

```bash
./scripts/install-homebrew.sh
./scripts/install-packages.sh
./scripts/install-extra-apps.sh
./scripts/macos-defaults.sh
./scripts/setup-shell.sh
```

## What it does

| Step | Script | Purpose |
|------|--------|---------|
| 1 | `scripts/install-homebrew.sh` | Install Homebrew if missing |
| 2 | `scripts/install-packages.sh` | Install everything in `Brewfile` |
| 3 | `scripts/install-extra-apps.sh` | Install apps not on Homebrew (GitHub DMGs, etc.) |
| 4 | `scripts/macos-defaults.sh` | Apply macOS preference defaults |
| 5 | `scripts/setup-shell.sh` | Optional shell tweaks (oh-my-zsh, etc.) |

## Customize

1. **Apps & tools** — Edit [`Brewfile`](Brewfile). Find package names with `brew search <name>`.
2. **Non-brew apps** — Add installers in [`scripts/install-extra-apps.sh`](scripts/install-extra-apps.sh) (currently: [Buffer](https://github.com/samirpatil2000/Buffer)).
3. **macOS settings** — Edit [`scripts/macos-defaults.sh`](scripts/macos-defaults.sh). Uncomment or add `defaults write` lines you want.
4. **Dotfiles** — Put configs in `dotfiles/` and symlink them from `scripts/link-dotfiles.sh` (add when ready).

## Tips

- Re-run `./scripts/install-packages.sh` anytime to sync new Brewfile entries.
- Re-run `./scripts/install-extra-apps.sh` to install new non-brew apps (skips ones already present).
- `brew bundle cleanup --force` removes packages not listed in the Brewfile (use carefully).
- Keep secrets out of this repo (API keys, SSH private keys). Use a password manager or a private vault.
