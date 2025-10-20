#!/bin/bash

# Format markdown files using nvim LSP
# Usage: format-markdown.sh [file.md]

if [ $# -eq 0 ]; then
  # Format all markdown files in current directory
  find . -name "*.md" -type f -exec nvim --headless -c "lua vim.lsp.buf.format({async=false})" -c "wqa" {} \; 2>/dev/null
else
  # Format specific file
  nvim --headless -c "lua vim.lsp.buf.format({async=false})" -c "wqa" "$1" 2>/dev/null
fi

echo "Markdown formatting complete"