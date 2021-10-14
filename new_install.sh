#!/bin/sh
echo -e "\u001b[32;1m Let's install some apps!\u001b[0m"

echo -e "\u001b[32;1m Install Homebrew\u001b[0m"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nvm
echo -e "\u001b[32;1m Install NVM\u001b[0m"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
echo -e "\u001b[32;1m Install Node\u001b[0m"
nvm install node

brew tap homebrew/cask
export HOMEBREW_CASK_OPTS="--appdir-/Applications"

xcode-select --install

# install Applications
echo -e "\u001b[32;1m Install our applications\u001b[0m"
## development
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask  transmit
brew install --cask  mamp
brew install --cask postman
brew install --cask tableplus

# productivity
brew install --cask slack
brew install --cask notion
brew install --cask flux
brew install --cask spectacle
brew install --cask the-unarchiver
brew install --cask dropbox
brew install --cask vlc


brew install --cask google-chrome
brew install --cask firefox

brew install --cask spotify

echo -e "\u001b[32;1m Set up iTerm & zsh \u001b[0m"
brew install --cask zsh
brew install --cask zsh-syntax-highlighting
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
cp .zshrc ~/.zshrc


echo -e "\u001b[32;1m Install VSCode extensions \u001b[0m"
code --install-extension gitlens
code --install-extension vscode-pigments
code --install-extension sass
code --install-extension python 
code --install-extension php-intelephense
code --install-extension highlight-matching-tag
code --install-extension eslint
code --install-extension prettier
code --install-extension babel


# brew clean up
brew cleanup

# Remove cask cruft
brew cask cleanup

# Link alfred to apps
brew cask alfred link
