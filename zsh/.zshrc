export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""
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
plugins=(git macos laravel vscode zsh-interactive-cd  zsh-navigation-tools zsh-syntax-highlighting node npm brew)

# Path to your oh-my-zsh installation.
export ZSH="/Users/$(whoami)/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

export PROMPT='%n@%m:%~%# '

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias lsa="ls -la"
alias gamed="git commit --amend --reuse-message HEAD"
alias gac="ga .; gc -m"

alias zshconf="nvim ~/.zshrc"
alias src-zsh="source ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

alias ghosttyconf="nvim ~/.config/ghostty/config"

alias tmuxconf="nvim ~/.tmux.conf"
alias src-tmux="tmux source ~/.tmux.conf"

alias sshKey="pbcopy < ~/.ssh/id_ed25519.pub"
alias sshConfig="nvim ~/.ssh/config"

alias sites="cd ~/Sites"
alias proj="cd ~/Projects"
alias wfb="proj; wfb"
alias lum="proj; luminoso"
alias art="php artisan"
alias vapor="php vendor/bin/vapor"
alias cur="proj; curology"
alias pok="proj; cd PocketDerm"
alias con="proj; conductor"
alias foll="proj; cd follett"
alias op="tmuxinator"

alias eve="proj; cd evelyn"
alias jnc="proj; junction-bank"

PATH=$PATH:~/bin
PATH=$PATH:~/usr/bin
PATH=$PATH:~/usr/local/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:~/usr/local/bin/composer
PATH=$PATH:~/.composer/vendor/bin
PATH=$PATH:/usr/local/mysql/bin

export JUPYTER_PATH=/opt/homebrew/share/jupyter 
export JUPYTER_CONFIG_PATH=/opt/homebrew/etc/jupyter

export PATH="$HOME/.rbenv/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/$(whoami)/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="/opt/herd/php/current/bin:$PATH"
export PATH="/Users/colin/.local/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openblas/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openblas/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"

# initialize pure prompt
autoload -U promptinit; promptinit
prompt pure

fpath=(~/.config/zsh/completions $fpath)

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Docker Desktop CLI completions
autoload -Uz compinit
compinit

export EDITOR='nvim'


# Initialize zoxide (must be at the end)
eval "$(zoxide init zsh)"

# Source local machine-specific configuration if it exists
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
