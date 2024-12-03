#!/bin/sh

echo -e "\u001b[32;1mLet's install some apps!\u001b[0m"

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
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask transmit
brew install --cask postman
brew install --cask tableplus

# productivity
brew install --cask slack
brew install --cask notion
brew install --cask flux
brew install --cask rectangle
brew install --cask the-unarchiver
brew install --cask vlc

brew install --cask google-chrome
brew install --cask firefox

brew install --cask spotify

# Install Arc browser
brew install --cask arc

# Install Raygun
echo -e "\u001b[32;1mInstall Raygun\u001b[0m"
sudo curl -O "https://downloads.raygun.com/APM/latest/RaygunAgent-macOS-(x64).zip"
sudo unzip -d ./raygun "RaygunAgent-macOS-(x64).zip"
sudo rm "RaygunAgent-macOS-(x64).zip"
sudo chmod +x -R ./raygun/*

echo -e "\u001b[32;1mSet up iTerm & zsh \u001b[0m"
brew install zsh
brew install zsh-syntax-highlighting
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp .zshrc ~/.zshrc

echo -e "\u001b[32;1mInstall VSCode extensions \u001b[0m"
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

# Remove cask cruft
brew cleanup
