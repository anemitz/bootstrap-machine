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

Do not prefix this command with `sudo`. The script must run as your user so Homebrew, Ghostty, and dotfiles land in your home directory. It prompts for `sudo` only when installing system packages (Linux) or Homebrew (new Mac). If `curl` is missing on Debian or Ubuntu, install it first with `sudo apt-get update && sudo apt-get install -y curl`. The first run may also ask for confirmation when changing the login shell. Sign in to `gh`, `codex`, `claude`, `grok`, and other account-backed tools separately.

## Update

```sh
./bootstrap-machine update
```

The installed command works from any directory:

```sh
bootstrap-machine update
```

`update` refreshes the downloaded archive, or fast-forwards a clean Git checkout. It then re-executes the newly fetched script, upgrades managed packages and standalone tools, and synchronizes Zim, TPM, and LazyVim plugins.

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
| Terminal tools | GitHub CLI (`gh`), btop, lazygit, and lazydocker |
| Omarchy shell tools | fzf, zoxide, ripgrep (`rg`), eza, fd, bat, tldr, yt-dlp, and try |
| Editor | Neovim, LazyVim, clangd, and clang-format |
| AI tools | Codex CLI, Claude Code, Grok Build, oh-my-pi (`omp`), and Herdr |
| AI runtime | Bun, used to install and update oh-my-pi |

AI CLIs use their publishers' installers. `try` uses its upstream script on Linux and the `tobi/try` tap on macOS.

### macOS packages

The script installs Homebrew when missing. It then manages these formulae:

```text
gh neovim btop lazydocker lazygit fzf zoxide ripgrep eza fd bat
tlrc yt-dlp tmux ruby llvm@18 try
```

Ghostty is installed with `brew install --cask ghostty`. `try` comes from `https://github.com/tobi/try`. The built-in macOS Zsh is retained. Homebrew confirmation prompts are disabled for unattended bootstrap runs.

### Ubuntu and Debian packages

The script first installs the bootstrap prerequisites:

```text
ca-certificates curl git gpg unzip tar gzip xz-utils build-essential
```

It configures GitHub CLI's official APT repository, then installs each available package from:

```text
zsh gh btop fzf ripgrep fd-find bat tmux ruby-full python3 python3-pip
pipx eza zoxide yt-dlp wl-clipboard xclip clangd-18 clang-format-18 ghostty
```

If Ghostty is not in the distro repositories, the script uses the community Ubuntu/Debian packages. The latest upstream Neovim and lazygit Linux releases are installed under `~/.local`. Missing or outdated eza, zoxide, and yt-dlp receive upstream fallbacks. lazydocker uses its upstream installer, tldr uses pipx, and try uses its upstream Ruby script. `fdfind` and `batcat` receive `fd` and `bat` compatibility links when required.

### Arch and Omarchy packages

The script installs each available package from:

```text
zsh git curl github-cli neovim btop lazygit fzf zoxide ripgrep eza fd bat
tealdeer yt-dlp tmux ruby python-pipx unzip base-devel wl-clipboard xclip clang
ghostty
```

It runs `pacman -Syu --needed`; Arch does not support partial upgrades. Missing lazydocker and try receive upstream installations. Other missing portable tools use the same Linux fallbacks where available.

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
- Configures eza as `ls`, bat as `cat`, zoxide as `cd`, fzf shell integration, Git/tmux aliases, and `try` under `~/Work/tries`.
- Installs `clipboard-copy`, which uses `pbcopy`, `wl-copy`, or `xclip` for portable tmux clipboard copying.

Primary install references: [Omarchy shell tools](https://omarchy.org/manual/shell-tools/), [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md), [Codex CLI](https://developers.openai.com/codex/cli/), [Claude Code](https://code.claude.com/docs/en/quickstart), [Grok Build](https://x.ai/news/grok-build-cli), [oh-my-pi](https://github.com/can1357/oh-my-pi), and [Herdr](https://herdr.dev/docs/install/).

## Test

```sh
./tests/smoke.sh
```
