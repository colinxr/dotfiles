#!/bin/bash
# Setup script for local machine-specific configurations

set -e

CONFIG_DIR="$HOME/.config"
LOCAL_ZSH_CONFIG="$HOME/.zshrc.local"

echo "Setting up local machine configuration..."

# Create .zshrc.local if it doesn't exist
if [[ ! -f "$LOCAL_ZSH_CONFIG" ]]; then
    echo "Creating $LOCAL_ZSH_CONFIG from example..."
    cp "$CONFIG_DIR/zsh/.zshrc.local.example" "$LOCAL_ZSH_CONFIG"
    echo "✓ Created $LOCAL_ZSH_CONFIG"
    echo "  Edit this file to add your machine-specific settings"
else
    echo "✓ $LOCAL_ZSH_CONFIG already exists"
fi

# Create symlink for zshrc if it doesn't exist
if [[ ! -L "$HOME/.zshrc" ]]; then
    echo "Creating symlink for .zshrc..."
    ln -sf "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
    echo "✓ Created symlink: $HOME/.zshrc -> $CONFIG_DIR/zsh/.zshrc"
else
    echo "✓ .zshrc symlink already exists"
fi

echo ""
echo "Setup complete! Your local configuration is ready."
echo "Edit $LOCAL_ZSH_CONFIG to customize settings for this machine."
echo ""
echo "The following files are now configured:"
echo "  • $HOME/.zshrc (symlinked to $CONFIG_DIR/zsh/.zshrc)"
echo "  • $LOCAL_ZSH_CONFIG (machine-specific, gitignored)"
echo ""
echo "To reload your shell configuration:"
echo "  source ~/.zshrc"
