#!/bin/bash
# Setup dev window with horizontal split: nvim | opencode
# Creates two panes side by side (50/50)

# Create horizontal split, run opencode in right pane
tmux split-window -h -p 50 'opencode'

# Run nvim in left pane (current)
nvim
