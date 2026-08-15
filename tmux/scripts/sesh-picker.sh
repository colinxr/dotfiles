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

preview="$HOME/.config/tmux/scripts/sesh-preview.sh"

# Dracula palette matching the status line:
#   purple #bd93f9 borders/info, cyan #8be9fd cursor, orange #ffb86c prompt+matches,
#   comment #6272a4 hints, bg #282a36 / selection #44475a (current line).
selection=$(sesh list | fzf-tmux -p 90%,70% \
  --reverse \
  --prompt '❯ ' \
  --header 'enter: connect · ctrl-x: kill session · tab/btab: move' \
  --color 'bg:#282a36,bg+:#44475a,fg:#f8f8f2,fg+:#f8f8f2,gutter:#282a36,preview-bg:#21222c,preview-fg:#f8f8f2,border:#bd93f9,header:#6272a4,info:#bd93f9,pointer:#8be9fd,marker:#8be9fd,prompt:#ffb86c,hl:#ffb86c,hl+:#ffb86c,spinner:#ff79c6' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-x:execute-silent(tmux kill-session -t {} 2>/dev/null || true)+reload(sesh list)' \
  --preview "$preview {}" \
  --preview-window right,40%,border-left) || exit 0

# fzf-tmux replaces the tmux pane with the picker; on selection, attach.
sesh connect "$selection"