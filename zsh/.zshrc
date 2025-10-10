# Source actual configuration from XDG-compliant location
source "$HOME/.config/zsh/.zshrc"
nfiguration - Server Compatible
# ============================================================================

# XDG Base Directory compliance
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

# History configuration
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

# ============================================================================
# Oh My Zsh Setup
# ============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git zsh-interactive-cd zsh-navigation-tools)

# Load Oh My Zsh if available
if [[ -d "$ZSH" ]]; then
  source $ZSH/oh-my-zsh.sh
else
  # Fallback: basic zsh configuration
  autoload -U colors && colors
  autoload -Uz compinit && compinit
fi

# ============================================================================
# Prompt Configuration
# ============================================================================

# Load Pure prompt if available
if [[ -f ~/.oh-my-zsh/custom/themes/pure/async.zsh ]] && [[ -f ~/.oh-my-zsh/custom/themes/pure/pure.zsh ]]; then
  source ~/.oh-my-zsh/custom/themes/pure/async.zsh
  source ~/.oh-my-zsh/custom/themes/pure/pure.zsh
fi

# ============================================================================
# Completions
# ============================================================================

fpath=(~/.config/zsh/completions $fpath)

if command -v brew >/dev/null 2>&1; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi

# ============================================================================
# Syntax Highlighting
# ============================================================================

if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================================
# Core Aliases
# ============================================================================

# File operations
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias lsa='ls -la'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gamed='git commit --amend --reuse-message HEAD'
alias gac='ga .; gc -m'

# Configuration editing
alias zshconf='$EDITOR ~/.config/zsh/.zshrc'
alias src-zsh='source ~/.config/zsh/.zshrc'

# ============================================================================
# Tool Integrations
# ============================================================================

# Editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
elif command -v vim >/dev/null 2>&1; then
  export EDITOR='vim'
else
  export EDITOR='vi'
fi

# fzf - fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  # Try common installation paths
  if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  elif [[ -f /usr/local/share/fzf/key-bindings.zsh ]]; then
    source /usr/local/share/fzf/key-bindings.zsh
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi
  
  # Completion
  if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
  elif [[ -f /usr/local/share/fzf/completion.zsh ]]; then
    source /usr/local/share/fzf/completion.zsh
  fi
fi

# zoxide - smarter cd
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# bat - better cat
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
  alias bat='batcat'
fi

# Docker aliases
if command -v docker >/dev/null 2>&1; then
  alias d='docker'
  alias dps='docker ps'
  alias di='docker images'
  alias dex='docker exec -it'
  alias dlogs='docker logs -f'
fi

if command -v docker-compose >/dev/null 2>&1; then
  alias dc='docker-compose'
fi

# GitHub CLI
if command -v gh >/dev/null 2>&1; then
  alias ghr='gh repo'
  alias ghi='gh issue'
  alias ghp='gh pr'
fi

# ============================================================================
# Machine-Specific Configuration
# ============================================================================

# Source local configuration if it exists (desktop-specific tools, paths, aliases)
if [[ -f ~/.config/zsh/.zshrc.local ]]; then
  source ~/.config/zsh/.zshrc.local
fi
