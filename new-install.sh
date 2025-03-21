#!/bin/sh

echo -e "\u001b[32;1mLet's install some apps!\u001b[0m"

# Store the absolute path to the config directory
CONFIG_DIR=$(pwd)
echo -e "\u001b[32;1mConfig directory: $CONFIG_DIR\u001b[0m"

echo -e "\u001b[32;1mInstall Homebrew\u001b[0m"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nvm
echo -e "\u001b[32;1mInstall NVM\u001b[0m"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.zsh | zsh
echo -e "\u001b[32;1mInstall Node\u001b[0m"
nvm install node

brew tap homebrew/cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

xcode-select --install

# install Applications
echo -e "\u001b[32;1mInstall our applications\u001b[0m"
## development
brew install ghostty
brew install --cask cursor
brew install --cask transmit
brew install --cask postman
brew install --cask tableplus
brew install --cask transmit
brew install docker
brew install fzf
brew install zoxide
brew install bat
brew install gh

# productivity
brew install --cask google-drive
brew install --cask slack
brew install --cask notion
brew install --cask notion-calendar
brew install --cask flux
brew install --cask rectangle
brew install --cask the-unarchiver
brew install --cask vlc
brew install --cask expressvpn
brew install --cask raycast

brew install --cask google-chrome
brew install --cask firefox
brew install --cask arc
brew install --cask spotify
brew install --cask git-credential-manager

echo -e "\u001b[32;1mSet up iTerm & zsh \u001b[0m"
brew install zsh
brew install zsh-syntax-highlighting

brew install jesseduffield/lazygit/lazygit
brew install lazygit

brew install jesseduffield/lazydocker/lazydocker
brew install lazydocker

echo -e "\u001b[32;1mCreate symlinks for configuration files\u001b[0m"
# Backup existing config files
mkdir -p ~/.config_backup

# ZSH config
if [ -f ~/.zshrc ]; then
  mv ~/.zshrc ~/.config_backup/.zshrc.backup
fi
ln -sf "$CONFIG_DIR/zsh/.zshrc" ~/.zshrc
echo "Symlinked .zshrc"

# Git config
if [ -f ~/.gitconfig ]; then
  mv ~/.gitconfig ~/.config_backup/.gitconfig.backup
fi
ln -sf "$CONFIG_DIR/git/gitconfig" ~/.gitconfig
echo "Symlinked gitconfig"

# Neovim config
if [ -d ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config_backup/nvim.backup
fi
mkdir -p ~/.config
ln -sf "$CONFIG_DIR/nvim" ~/.config/nvim
echo "Symlinked nvim config"

# Ghostty config
mkdir -p ~/.config/ghostty
if [ -f ~/.config/ghostty/config ]; then
  mv ~/.config/ghostty/config ~/.config_backup/ghostty.config.backup
fi
ln -sf "$CONFIG_DIR/ghostty" ~/.config/
echo "Symlinked ghostty config"

# Tmux config
if [ -f ~/.tmux.conf ]; then
  mv ~/.tmux.conf ~/.config_backup/.tmux.conf.backup
fi
if [ -d ~/.tmux/plugins ]; then
  mv ~/.tmux/plugins ~/.config_backup/tmux_plugins.backup
fi
mkdir -p ~/.tmux
ln -sf "$CONFIG_DIR/tmux/plugins" ~/.tmux/plugins
# Create a basic tmux.conf that sources your plugins if needed
# echo "source $CONFIG_DIR/tmux/plugins/catppuccin/catppuccin.tmux" > ~/.tmux.conf
echo "Symlinked tmux plugins"

# Raycast config
if [ -f ~/.config/raycast.rayconfig ]; then
  mv ~/.config/raycast.rayconfig ~/.config_backup/raycast.rayconfig.backup
fi
ln -sf "$CONFIG_DIR/raycast.rayconfig" ~/.config/raycast.rayconfig
echo "Symlinked raycast config"

echo -e "\u001b[32;1mInstall VSCode/Cursor extensions \u001b[0m"
cursor --install-extension gitlens
cursor --install-extension vscode-pigments
cursor --install-extension sass-indented
cursor --install-extension ms-python.python
cursor --install-extension bmewburn.vscode-intelephense-client
cursor --install-extension vincaslt.highlight-matching-tag
cursor --install-extension dbaeumer.vscode-eslint
cursor --install-extension esbenp.prettier-vscode
cursor --install-extension mgmcdermott.vscode-language-babel

code --install-extension gitlens
code --install-extension vscode-pigments
code --install-extension sass-indented
code --install-extension ms-python.python
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension vincaslt.highlight-matching-tag
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension mgmcdermott.vscode-language-babel

# brew clean up
brew cleanup

echo -e "\u001b[32;1mSetup complete! You may want to restart your terminal.\u001b[0m"
