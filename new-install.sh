#!/bin/sh

echo -e "Let's install some apps!"

# Store the absolute path to the config directory
CONFIG_DIR=$(pwd)
echo -e "Config directory: $CONFIG_DIR"

echo -e "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nvm
echo -e "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
echo -e "Install Node"
nvm install node

brew tap homebrew/cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

xcode-select --install

# install Applications
echo -e "Install our applications"
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

brew install zsh
brew install zsh-syntax-highlighting

brew install jesseduffield/lazygit/lazygit
brew install lazygit

brew install jesseduffield/lazydocker/lazydocker
brew install lazydocker

echo -e "Create symlinks for configuration files"
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

# Ghostty config
mkdir -p ~/Library/Application\ Support/Ghostty

ln -sf "$CONFIG_DIR/ghostty/config" ~/Library/Application\ Support/Ghostty/config
echo "Symlinked ghostty config"

# Tmux config
if [ -f ~/.tmux.conf ]; then
  mv ~/.tmux.conf ~/.config_backup/.tmux.conf.backup
fi
ln -sf "$CONFIG_DIR/tmux/tmux.conf" ~/.tmux.conf
echo "Symlinked tmux.conf"

echo -e "Install VSCode/Cursor extensions "
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

echo -e "Setup complete! You may want to restart your terminal."
