#!/bin/sh
echo Let\'s install some apps!

echo Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# nvm
echo Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
echo Nnstall Node
nvm install node

brew tap caskroom/cask
export HOMEBREW_CASK_OPTS="--appdir-/Applications"

xcode-select --install

# install Applications
echo Install our applications
## development
brew cask install iterm2
brew cask install visual-studio-code
brew cask install transmit
brew cask install mysqlworkbench
brew cask install mamp
brew cask install postman

# productivity
brew cask install slack
brew cask install notion
brew cask install flux
brew cask install spectacle
brew cask install the-unarchiver
brew cask install dropbox
brew cask install vanilla
brew cask install google-drive


brew cask install google-chrome
brew cask install firefox

brew cask install sketch
brew cask install spotify

echo Set up iTerm & zsh
brew install zsh
brew install zsh-syntax-highlighting
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo Install WP-Cli
# wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

echo install VSCode extensions
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
