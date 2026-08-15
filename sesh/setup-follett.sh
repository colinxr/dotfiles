#!/bin/bash
# Setup follett dev window with 3-pane layout
# Layout: nvim (left 65%) | empty (top right 35%) 
#                         | opencode (bottom right)

# Create main vertical split (nvim gets 65% on left)
tmux split-window -h -p 35

# Split right side horizontally (creates 2nd pane on top, moves opencode to bottom)
tmux split-window -v -p 50 -t 1

# Send commands to specific panes
tmux send-keys -t 0 'nvim' C-m
tmux send-keys -t 2 'opencode' C-m

# Focus back to nvim pane
tmux select-pane -t 0
