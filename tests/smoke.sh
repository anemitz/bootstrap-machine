#!/bin/sh

set -eu

TEST_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

sh -n "$TEST_ROOT/bootstrap-machine"
bash -n "$TEST_ROOT/bootstrap-machine"
sh -n "$TEST_ROOT/bin/clipboard-copy"
zsh -n "$TEST_ROOT/dotfiles/zshrc"
zsh -n "$TEST_ROOT/dotfiles/zshenv"

mac_output=$(BOOTSTRAP_MACHINE_PLATFORM=macos BOOTSTRAP_MACHINE_DRY_RUN=1 BOOTSTRAP_MACHINE_UPDATING=1 "$TEST_ROOT/bootstrap-machine" install)
printf '%s\n' "$mac_output" | grep -q 'Homebrew packages'
printf '%s\n' "$mac_output" | grep -q ghostty
printf '%s\n' "$mac_output" | grep -q 'install-rosetta --agree-to-license'
printf '%s\n' "$mac_output" | grep -q 'sh.rustup.rs'
printf '%s\n' "$mac_output" | grep -q 'astral.sh/uv/install.sh'
printf '%s\n' "$mac_output" | grep -q 'Codex CLI'
printf '%s\n' "$mac_output" | grep -q 'opencode.ai/install'
printf '%s\n' "$mac_output" | grep -q 'earendil-works/pi-coding-agent'
printf '%s\n' "$mac_output" | grep -q 'oh-my-pi'
printf '%s\n' "$mac_output" | grep -q 'basecamp/gh-signoff'

apt_output=$(BOOTSTRAP_MACHINE_PLATFORM=linux BOOTSTRAP_MACHINE_PACKAGE_MANAGER=apt BOOTSTRAP_MACHINE_DRY_RUN=1 BOOTSTRAP_MACHINE_UPDATING=1 "$TEST_ROOT/bootstrap-machine" install)
printf '%s\n' "$apt_output" | grep -q 'APT packages'
printf '%s\n' "$apt_output" | grep -q ghostty
printf '%s\n' "$apt_output" | grep -q 'sh.rustup.rs'
printf '%s\n' "$apt_output" | grep -q 'astral.sh/uv/install.sh'
printf '%s\n' "$apt_output" | grep -q qemu-system
printf '%s\n' "$apt_output" | grep -q 'opencode.ai/install'
printf '%s\n' "$apt_output" | grep -q 'official Linux tarball'
printf '%s\n' "$apt_output" | grep -q 'basecamp/gh-signoff'

pacman_output=$(BOOTSTRAP_MACHINE_PLATFORM=linux BOOTSTRAP_MACHINE_PACKAGE_MANAGER=pacman BOOTSTRAP_MACHINE_DRY_RUN=1 BOOTSTRAP_MACHINE_UPDATING=1 "$TEST_ROOT/bootstrap-machine" install)
printf '%s\n' "$pacman_output" | grep -q 'pacman -Syu'
printf '%s\n' "$pacman_output" | grep -q ghostty
printf '%s\n' "$pacman_output" | grep -q 'sh.rustup.rs'
printf '%s\n' "$pacman_output" | grep -q 'astral.sh/uv/install.sh'
printf '%s\n' "$pacman_output" | grep -q qemu-desktop
printf '%s\n' "$pacman_output" | grep -q 'opencode.ai/install'
printf '%s\n' "$pacman_output" | grep -q 'basecamp/gh-signoff'

update_output=$(BOOTSTRAP_MACHINE_DRY_RUN=1 "$TEST_ROOT/bootstrap-machine" update)
printf '%s\n' "$update_output" | grep -q 'git -C'
printf '%s\n' "$update_output" | grep -q 'Dry run complete'

standalone_directory=$(mktemp -d "${TMPDIR:-/tmp}/bootstrap-machine-test.XXXXXX")
cp "$TEST_ROOT/bootstrap-machine" "$standalone_directory/launcher"
standalone_output=$(BOOTSTRAP_MACHINE_DRY_RUN=1 "$standalone_directory/launcher")
printf '%s\n' "$standalone_output" | grep -q 'Fetching bootstrap-machine configuration'
printf '%s\n' "$standalone_output" | grep -q 'main.tar.gz'

mkdir -p "$standalone_directory/archive/bootstrap-machine-main" "$standalone_directory/home"
cp -R "$TEST_ROOT/." "$standalone_directory/archive/bootstrap-machine-main/"
rm -rf -- "$standalone_directory/archive/bootstrap-machine-main/.git"
tar -czf "$standalone_directory/main.tar.gz" -C "$standalone_directory/archive" bootstrap-machine-main
set +e
archive_output=$(HOME="$standalone_directory/home" \
  BOOTSTRAP_MACHINE_ARCHIVE_URL="file://$standalone_directory/main.tar.gz" \
  BOOTSTRAP_MACHINE_SOURCE_ROOT="$standalone_directory/home/source" \
  "$standalone_directory/launcher" doctor 2>&1)
archive_status=$?
set -e
[ "$archive_status" -le 1 ]
[ -x "$standalone_directory/home/source/bootstrap-machine" ]
[ -f "$standalone_directory/home/source/dotfiles/zshrc" ]
printf '%s\n' "$archive_output" | grep -q 'Fetching bootstrap-machine configuration'
printf '%s\n' "$archive_output" | grep -q '^zsh'
archive_update_output=$(HOME="$standalone_directory/home" \
  BOOTSTRAP_MACHINE_ARCHIVE_URL="file://$standalone_directory/main.tar.gz" \
  BOOTSTRAP_MACHINE_SOURCE_ROOT="$standalone_directory/home/source" \
  BOOTSTRAP_MACHINE_DRY_RUN=1 \
  "$standalone_directory/home/source/bootstrap-machine" update)
printf '%s\n' "$archive_update_output" | grep -q 'Fetching bootstrap-machine configuration'
if printf '%s\n' "$archive_update_output" | grep -q 'git -C'
then
  printf 'archive update unexpectedly selected Git\n' >&2
  exit 1
fi
rm -rf -- "$standalone_directory"

printf 'smoke tests passed\n'
