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

# History Search - up/down arrows search based on what you've typed
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# NVM - lazy loaded (see function at end of file)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH



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
alias gco="git checkout"
alias gst="git status"
alias gamed="git commit --amend --reuse-message HEAD"
alias gac="git add -A; git commit -m"

alias zshconf="nvim ~/.config/zsh/.zshrc"
alias zshconfig-local="nvim ~/.zshrc"
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
alias tms="tmuxinator start"

# Tmuxinator aliases
alias tms-dot="tmuxinator start dotfiles"
alias tms-eve="tmuxinator start evelyn" 
alias tms-fol="tmuxinator start follett"
alias tml="tmuxinator list"
alias tmk="tmux kill-session -t"
alias tmks="tmux kill-server"
alias tme="tmuxinator edit"
alias tme-dot="tmuxinator edit dotfiles"
alias tme-eve="tmuxinator edit evelyn"
alias tme-fol="tmuxinator edit follett"
alias tma="tmux attach -t"
alias tmls="tmux ls"
alias tmns="tmux new-session -s"

PATH=$PATH:~/bin
PATH=$PATH:~/usr/bin
PATH=$PATH:~/usr/local/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:~/usr/local/bin/composer
PATH=$PATH:~/.composer/vendor/bin
PATH=$PATH:/usr/local/mysql/bin
PATH=$PATH:~/.config/.tmuxifier/bin

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

# Optimized compinit - cache for 24h
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

export EDITOR='nvim'

# Initialize Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    # Fallback prompt if starship not installed
    export PROMPT='%n@%m:%~%# '
fi

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

if command -v tmuxifier >/dev/null @>&1; then
  eval "$(tmuxifier init -)"
fi

# Syntax highlighting (load last for performance)
if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Source local machine-specific configuration if it exists
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
