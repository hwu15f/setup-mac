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
./scripts/macos-defaults.sh
./scripts/setup-shell.sh
```

## What it does

| Step | Script | Purpose |
|------|--------|---------|
| 1 | `scripts/install-homebrew.sh` | Install Homebrew if missing |
| 2 | `scripts/install-packages.sh` | Install everything in `Brewfile` |
| 3 | `scripts/macos-defaults.sh` | Apply macOS preference defaults |
| 4 | `scripts/setup-shell.sh` | Optional shell tweaks (oh-my-zsh, etc.) |

## Customize

1. **Apps & tools** — Edit [`Brewfile`](Brewfile). Find package names with `brew search <name>`.
2. **macOS settings** — Edit [`scripts/macos-defaults.sh`](scripts/macos-defaults.sh). Uncomment or add `defaults write` lines you want.
3. **Dotfiles** — Put configs in `dotfiles/` and symlink them from `scripts/link-dotfiles.sh` (add when ready).

## Tips

- Re-run `./scripts/install-packages.sh` anytime to sync new Brewfile entries.
- `brew bundle cleanup --force` removes packages not listed in the Brewfile (use carefully).
- Keep secrets out of this repo (API keys, SSH private keys). Use a password manager or a private vault.
