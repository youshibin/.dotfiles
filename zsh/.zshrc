# ~/.zshrc - Interactive shell configuration

# ============================================================================
# TERMINAL TITLE
# ============================================================================
# Disable automatic terminal title updates (Zellij will manage pane titles)
DISABLE_AUTO_TITLE="true"

# ============================================================================
# COMPLETION SYSTEM
# ============================================================================
# IMPORTANT: Initialize completion system BEFORE loading plugins
autoload -Uz compinit
compinit

# ============================================================================
# ANTIDOTE PLUGIN MANAGER
# ============================================================================
# Install antidote if it doesn't exist
ANTIDOTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

# Source antidote
source "$ANTIDOTE_DIR/antidote.zsh"

# Load plugins from .zsh_plugins.txt
antidote load

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

# Create history directory if it doesn't exist
mkdir -p "$(dirname "$HISTFILE")"

# History options
setopt EXTENDED_HISTORY          # Write timestamp to history file
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming
setopt HIST_IGNORE_DUPS          # Don't record duplicate entries
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_VERIFY               # Show command with history expansion before running
setopt SHARE_HISTORY             # Share history between all sessions

# Standard history search (searches commands that START with typed text)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind up/down arrows to history search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ============================================================================
# SHELL KEYBINDINGS (ZLE - Zsh Line Editor)
# ============================================================================
#
# ----------------------------------------------------------------------------
# HISTORY SEARCH
# ----------------------------------------------------------------------------
# CTRL+R for fuzzy reverse search (via fzf if installed)
bindkey "^R" history-incremental-search-backward

# ----------------------------------------------------------------------------
# SHELL UTILITIES
# ----------------------------------------------------------------------------
# CTRL+L clears screen (zsh default)
# CTRL+C cancels current command (terminal standard)
# CTRL+D exits shell when line is empty (terminal standard)

# ============================================================================
# MODERN TOOL ALIASES
# ============================================================================
# Check if modern tools are installed before aliasing

# eza (modern ls replacement)
if command -v eza &> /dev/null; then
  alias ls='eza --icons'
  alias la='eza -la --icons --git'
  alias ll='eza -l --icons --git'
  alias lt='eza --tree --level=2 --icons'
  alias tree='eza --tree --icons'
else
  # Fallback to standard ls with colors
  alias ls='ls -G'
  alias la='ls -FG1Ahp'
  alias ll='ls -lhG'
fi

# bat (modern cat replacement)
if command -v bat &> /dev/null; then
  alias cat='bat --paging=never'
  alias batl='bat'  # bat with paging for long files
fi

# fd (modern find replacement)
if command -v fd &> /dev/null; then
  alias find='fd'
fi

# ============================================================================
# MIGRATED ALIASES
# ============================================================================
# Safe and verbose file operations
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

# Quick find (if fd not available, fallback to traditional find)
if ! command -v fd &> /dev/null; then
  alias qfind='find . -name'
fi

# Open current directory in Finder (macOS)
alias f='open -a Finder ./'

# ============================================================================
# ADDITIONAL USEFUL ALIASES
# ============================================================================
# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Quick config edits
alias zshconfig='$EDITOR ~/.zshrc'
alias zshlocal='$EDITOR ~/.zshrc.local'

# Reload zsh config
alias reload='source ~/.zshrc'

# ============================================================================
# STARSHIP PROMPT
# ============================================================================
# Initialize Starship prompt (must be at the end of .zshrc)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback to a simple prompt if Starship isn't installed
  PROMPT='%F{cyan}%~%f %# '
fi

# ============================================================================
# LOCAL OVERRIDES
# ============================================================================
# Source machine-specific configuration if it exists
# Use this for work-specific configs, local PATH additions, etc.
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
