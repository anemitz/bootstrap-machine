# bootstrap-machine

Bootstrap a personal terminal environment on macOS, Ubuntu/Debian, or Arch/Omarchy.

## Install

No GitHub CLI or repository clone is required:

```sh
curl -fsSL https://raw.githubusercontent.com/anemitz/bootstrap-machine/main/bootstrap-machine | bash
```

To inspect the script before running it instead:

```sh
curl -fsSLo bootstrap-machine https://raw.githubusercontent.com/anemitz/bootstrap-machine/main/bootstrap-machine
chmod +x bootstrap-machine
./bootstrap-machine
```

The launcher downloads the configuration archive to `~/.local/share/bootstrap-machine/source`, installs `~/.local/bin/bootstrap-machine`, and continues without a Git checkout. Alternatively, use a Git checkout:

```sh
git clone https://github.com/anemitz/bootstrap-machine.git ~/code/bootstrap-machine
cd ~/code/bootstrap-machine
./bootstrap-machine
```

The script installs packages, backs up conflicting dotfiles, links this repository's configuration, installs shell and Neovim plugins, and makes `vim` invoke Neovim. Existing files move under `~/.local/state/bootstrap-machine/backups/` before linking.

Do not prefix this command with `sudo`. The script must run as your user so Homebrew, Ghostty, and dotfiles land in your home directory. It prompts for `sudo` only when installing system packages (Linux) or Homebrew (new Mac). If `curl` is missing on Debian or Ubuntu, install it first with `sudo apt-get update && sudo apt-get install -y curl`. The first run may also ask for confirmation when changing the login shell. Sign in to `gh`, `codex`, `claude`, `grok`, `opencode`, and other account-backed tools separately.

## Update

```sh
./bootstrap-machine update
```

The installed command works from any directory:

```sh
bootstrap-machine update
```

`update` refreshes the downloaded archive, or fast-forwards a clean Git checkout. It then re-executes the newly fetched script, upgrades managed packages and standalone tools (including rustup), and synchronizes Zim, TPM, and LazyVim plugins.

Inspect changes without modifying the machine:

```sh
./bootstrap-machine update --dry-run
```

Report missing commands:

```sh
./bootstrap-machine doctor
```

## Everything installed

### On every platform

| Group | Installed tools |
| --- | --- |
| Shell | Zsh, Zim, Powerlevel10k, and tmux |
| Terminal | Ghostty |
| Terminal tools | GitHub CLI (`gh`) with the `basecamp/gh-signoff` extension, btop, lazygit, and lazydocker |
| Omarchy shell tools | fzf, zoxide, ripgrep (`rg`), eza, fd, bat, tldr, and yt-dlp |
| Editor | Neovim, LazyVim, clangd, and clang-format |
| AI tools | Codex CLI, Claude Code, Grok Build, OpenCode, Pi (`pi`), oh-my-pi (`omp`), and Herdr |
| AI runtime | Bun, used to install and update Pi and oh-my-pi |
| Language | Rust via rustup (`rustc`, `cargo`, rustfmt, and clippy); Python via uv (`uv`, `uvx`) |
| Virtualization | QEMU (`qemu-img` and system emulators) |

AI CLIs use their publishers' installers, except Pi and oh-my-pi which Bun installs from npm. Rust uses the official rustup installer on every platform. uv uses Astral's official installer on every platform. After GitHub CLI is installed, the script runs `gh extension install basecamp/gh-signoff` so `gh signoff` is available.

### macOS packages

The script installs Homebrew when missing. It then manages these formulae:

```text
gh neovim btop lazydocker lazygit fzf zoxide ripgrep eza fd bat
tlrc yt-dlp tmux llvm@18 colima docker ollama qemu
```

Ghostty is installed with `brew install --cask ghostty`. Colima and the Docker CLI provide a local container runtime; start it with `colima start` after install. Ollama is the CLI (`brew install ollama`); start it with `ollama serve` and pull models separately. QEMU is the `qemu` formula. On Apple Silicon, the script installs Rosetta 2 with `softwareupdate --install-rosetta --agree-to-license`. The built-in macOS Zsh is retained. Homebrew confirmation prompts are disabled for unattended bootstrap runs.

### Ubuntu and Debian packages

The script first installs the bootstrap prerequisites:

```text
ca-certificates curl git gpg unzip tar gzip xz-utils build-essential
```

It configures GitHub CLI's official APT repository, then installs each available package from:

```text
zsh gh btop fzf ripgrep fd-find bat tmux python3 python3-pip
pipx eza zoxide yt-dlp wl-clipboard xclip clangd-18 clang-format-18 ghostty
qemu-system qemu-utils qemu-kvm
```

If Ghostty is not in the distro repositories, the script uses the community Ubuntu/Debian packages. The latest upstream Neovim and lazygit Linux releases are installed under `~/.local`. Missing or outdated eza, zoxide, and yt-dlp receive upstream fallbacks. lazydocker uses its upstream installer, and tldr uses pipx. `fdfind` and `batcat` receive `fd` and `bat` compatibility links when required.

### Arch and Omarchy packages

The script installs each available package from:

```text
zsh git curl github-cli neovim btop lazygit fzf zoxide ripgrep eza fd bat
tealdeer yt-dlp tmux python-pipx unzip base-devel wl-clipboard xclip clang
ghostty qemu-desktop
```

It runs `pacman -Syu --needed`; Arch does not support partial upgrades. Missing lazydocker receives its upstream installer. Other missing portable tools use the same Linux fallbacks where available.

Package managers may install additional transitive dependencies. Those vary by operating-system release and are not selected directly by this repository.

### Configuration and plugins

The repository links these managed files, backing up conflicts under `~/.local/state/bootstrap-machine/backups/`:

```text
~/.zshrc
~/.zshenv
~/.zimrc
~/.p10k.zsh
~/.tmux.conf
~/.config/nvim
~/.local/bin/bootstrap-machine
~/.local/bin/clipboard-copy
```

It also:

- Links `~/.local/bin/vim` to Neovim and sets `EDITOR` and `VISUAL` to `nvim`.
- Offers to set Zsh as the login shell when run interactively.
- Installs Zim completions, syntax highlighting, history substring search, autosuggestions, and Powerlevel10k.
- Installs TPM with tmux-sensible, tmux-resurrect, tmux-continuum, and tmux-yank.
- Synchronizes LazyVim and adds clangd/clang-format C++ support, vim-tmux-navigator, lazygit.nvim, Harpoon, Oil, Trouble, Zen Mode, and super-tab completion.
- Configures eza as `ls`, bat as `cat`, zoxide as `cd`, fzf shell integration, and Git/tmux aliases.
- Installs `clipboard-copy`, which uses `pbcopy`, `wl-copy`, or `xclip` for portable tmux clipboard copying.

Primary install references: [Omarchy shell tools](https://omarchy.org/manual/shell-tools/), [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md), [Rustup](https://rustup.rs/), [uv](https://docs.astral.sh/uv/getting-started/installation/), [Codex CLI](https://developers.openai.com/codex/cli/), [Claude Code](https://code.claude.com/docs/en/quickstart), [Grok Build](https://x.ai/news/grok-build-cli), [OpenCode](https://opencode.ai/docs), [Pi](https://pi.dev/docs/latest), [oh-my-pi](https://github.com/can1357/oh-my-pi), [Herdr](https://herdr.dev/docs/install/), and [gh-signoff](https://github.com/basecamp/gh-signoff).

## Test

```sh
./tests/smoke.sh
```
