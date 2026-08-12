#!/bin/sh
# sesh session picker — invoked by the tmux keybind `prefix s`.
# Resolves sesh from PATH, falling back to ~/go/bin (the default `go install`
# location) so it works on a fresh machine where tmux's server env doesn't
# yet include $HOME/go/bin on PATH.

case ":$PATH:" in
  *":$HOME/go/bin:"*) ;;
  *) PATH="$HOME/go/bin:$PATH" ;;
esac

if ! command -v sesh >/dev/null 2>&1; then
  echo "sesh not found — install with: scripts/install-core.sh (or go install github.com/joshmedeski/sesh@latest)" >&2
  read -r dummy
  exit 1
fi

if ! command -v fzf-tmux >/dev/null 2>&1; then
  echo "fzf-tmux not found — install fzf" >&2
  read -r dummy
  exit 1
fi

selection=$(sesh list | fzf-tmux -p 80%,70%) || exit 0

# fzf-tmux replaces the tmux pane with the picker; on selection, attach.
sesh connect "$selection"