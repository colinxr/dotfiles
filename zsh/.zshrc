# ============================================================================
# Performance Optimizations
# To profile startup time: zmodload zsh/zprof at top, zprof at bottom
# Or use: time zsh -i -c exit
# ============================================================================

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# NVM - lazy loaded (see function at end of file)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

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
# Minimal set for performance - only essential plugins
plugins=(git zsh-syntax-highlighting)

# Add platform-specific plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
    plugins+=(macos)
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Performance optimizations for Oh My Zsh
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Skip git status for untracked files

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

# macOS-specific paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    export JUPYTER_PATH=/opt/homebrew/share/jupyter 
    export JUPYTER_CONFIG_PATH=/opt/homebrew/etc/jupyter
    export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
    export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
    export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
    export PATH="/opt/herd/php/current/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/openblas/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/openblas/include"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"
fi

# Set up completions path
fpath=(~/.config/zsh/completions $fpath)

# Initialize Pure prompt
if [[ -d ~/.oh-my-zsh/custom/themes/pure ]]; then
    fpath+=(~/.oh-my-zsh/custom/themes/pure)
    autoload -U promptinit; promptinit
    prompt pure
else
    # Fallback to simple prompt
    export PROMPT='%n@%m:%~%# '
fi

# Optimized compinit - cache for 24h
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

export EDITOR='nvim'

# ============================================================================
# Deferred/Lazy Loading for Performance
# ============================================================================

# Lazy load NVM - only initialize when node/npm/nvm is called
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # Add NVM's default node to path without loading full nvm
    if [[ -d "$NVM_DIR/versions/node" ]]; then
        NODE_GLOBALS=($NVM_DIR/versions/node/*/bin/*(N))
        if [[ -n "$NODE_GLOBALS" ]]; then
            export PATH="${NODE_GLOBALS[-1]}:$PATH"
        fi
    fi
    
    # Lazy load function - only load nvm when actually called
    nvm() {
        unfunction nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm "$@"
    }
    
    node() {
        unfunction nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        node "$@"
    }
    
    npm() {
        unfunction nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        npm "$@"
    }
    
    npx() {
        unfunction nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        npx "$@"
    }
fi

# Lazy load zoxide - initialize in background
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Source local machine-specific configuration if it exists
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
