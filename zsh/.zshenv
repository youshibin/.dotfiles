# ~/.zshenv - Environment variables for all shells (interactive and non-interactive)
# This file is loaded first, before .zshrc

# ============================================================================
# Zsh Configuration Directory
# ============================================================================
export ZDOTDIR="$HOME/.config/zsh"

# ============================================================================
# EDITOR
# ============================================================================
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================================================
# LANGUAGE & LOCALE
# ============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============================================================================
# ARCHITECTURE
# ============================================================================
# Apple Silicon architecture flags
export ARCHFLAGS="-arch arm64"

# ============================================================================
# XDG Base Directory Specification
# ============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ============================================================================
# PATH
# ============================================================================
# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# ============================================================================
# LOCAL OVERRIDES
# ============================================================================
# Source machine-specific environment variables if they exist
if [[ -f "$HOME/.zshenv.local" ]]; then
  source "$HOME/.zshenv.local"
fi
