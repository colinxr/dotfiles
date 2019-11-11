# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/article-mbp/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=powerlevel10k/powerlevel10k
DISABLE_AUTO_TITLE="true"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git osx zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

## Set PHP Version for MAMP and WP-CLI
PHP_VERSION=$(ls /Applications/MAMP/bin/php/ | sort -n | tail -1)
## Set color variables for function output
RED='\033[0;91m'
GREEN='\033[0;92m'
BLUE='\033[0;96m'
YELLOW='\033[0;93m'
NC='\033[0m' # No Color

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias src-zsh="source ~/.zshrc"
alias php7="/Applications/MAMP/bin/php/php7.3.1/bin/php"
alias art="php artisan"
alias addHost="code /etc/hosts"
alias addVHost="code /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf"
alias sites="cd ~/Sites"
alias themes="cd wp-content/themes"
alias git-ammend="git commit --amend --reuse-message HEAD"
alias gpop="git push; git push production"
alias gpos="git push; git push staging"
alias lkspush="gp; phploy"

alias phploy-staging="php phploy staging"
alias phploy-prod="php phploy production"


function create-new-project() {
  echo "\n"
  echo "Creating a new project at ${GREEN}$PWD/$1${NC}"
  echo "\n"
  git clone git@bitbucket.org:exsiteincteam/starter-kit.git $1
  echo "\n"
  echo "Cloning finished."
  echo "Make sure to update your virtual host configuration with the info below: "
  echo "\n"
  echo "hosts:"
  echo "${GREEN}127.0.0.1	$1${NC}"
  echo "httpd-vhosts.conf:"
  echo "${GREEN}<VirtualHost *:80>
     DocumentRoot \"/Users/article-mbp/Sites/$1\"
     ServerName $1
     ServerAlias $1
     ErrorLog logs/$1-error_log
     CustomLog logs/$1-access_log common
  </VirtualHost>${NC}"
  echo "New alias to add: ${GREEN}sites; cd $1${NC}"
  echo "\n"
  cd $1;
  git checkout dev
  mv base/*(DN) $PWD
  rm -rf base
  rm -rf base.zip
  rm -rf .git
  addHost
  addVHost
  zshconfig
  echo "\n"
  echo "Installing Modules ..."
  pnpm install
  git init
  git add -A
  git commit -m 'Initial Commit'
  echo "\n"
  echo "Happy hacking!"
  echo "\n"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export PATH=/bin:/usr/bin:/usr/local/bin:/Applications/MAMP/Library/bin/:/Applications/MAMP/bin/php/${PHP_VERSION}/bin:${PATH}:/$HOME/.composer/vendor/bin:/usr/local/php5-7.3.8/bin:$PATH
PATH=$PATH:~/bin
PATH=$PATH:~/usr/bin
PATH=$PATH:~/usr/local/bin
PATH=$PATH:~/Applications/MAMP/Library/bin/
PATH=$PATH:~/Applications/MAMP/Library/bin/php/${PHP_VERSION}/bin
PATH=$PATH:~/.composer/vendor/bin
PATH=$PATH:~/usr/local/opt/php@7.3/bin
PATH="/usr/local/opt/ruby/bin:$PATH"



## Make MAMP work with WP-CLI
# export PATH=$PATH
# export PATH=:$PATH
# export PATH=/Users/article-mbp/Library/Python/2.7/bin


echo -e "\033]6;1;bg;red;brightness;40\a"
echo -e "\033]6;1;bg;green;brightness;44\a"
echo -e "\033]6;1;bg;blue;brightness;52\a"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh