#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script
# ============================================================================
# This script installs and configures a complete terminal development
# environment with WezTerm, Zsh, Starship, Zellij, and LazyVim.
#
# Usage: ./install.sh
# ============================================================================

set -e # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_info() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

# ============================================================================
# BACKUP EXISTING DOTFILES
# ============================================================================

backup_dotfiles() {
    print_header "Backing up existing dotfiles"

    BACKUP_DIR="$HOME/.config/backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    # Backup both old-style (home directory) and new-style (XDG) configs
    local files=(
        ".zshrc"                    # Old-style zsh config in home
        ".zshenv"                   # Environment file (always in home)
        ".config/zsh"               # New XDG-style zsh config directory
        ".config/wezterm"           # WezTerm config directory
        ".config/starship.toml"     # Starship prompt config
        ".config/zellij"            # Zellij config directory
        ".config/nvim"              # Neovim config directory
        ".config/brew"              # Homebrew Brewfile directory
        ".config/Makefile"          # Development Makefile
    )

    for file in "${files[@]}"; do
        if [[ -e "$HOME/$file" ]]; then
            print_info "Backing up ~/$file"
            cp -r "$HOME/$file" "$BACKUP_DIR/"
        fi
    done

    if [[ $(ls -A "$BACKUP_DIR" 2>/dev/null) ]]; then
        print_success "Backup created at $BACKUP_DIR"
    else
        rmdir "$BACKUP_DIR"
        print_info "No existing dotfiles to backup"
    fi
}

# ============================================================================
# INSTALL HOMEBREW AND TOOLS
# ============================================================================

install_tools() {
    print_header "Installing Homebrew and tools"
    print_info "Running: make brew-bundle-install"
    make -f make/.config/Makefile brew-bundle-install
    print_success "All tools installed"
}

# ============================================================================
# STOW DOTFILES
# ============================================================================

stow_dotfiles() {
    print_header "Symlinking dotfiles with GNU Stow"
    print_info "Running: make stow"
    make -f make/.config/Makefile stow
    print_success "All packages stowed"
}

# ============================================================================
# SET DEFAULT SHELL
# ============================================================================

set_default_shell() {
    print_header "Setting Zsh as default shell"

    if [[ "$SHELL" == *"zsh"* ]]; then
        print_success "Zsh is already the default shell"
        return
    fi

    local zsh_path
    zsh_path=$(which zsh)

    # Add zsh to allowed shells if not already there
    if ! grep -q "$zsh_path" /etc/shells; then
        print_info "Adding $zsh_path to /etc/shells (requires sudo)"
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi

    # Change default shell
    print_info "Changing default shell to zsh (requires sudo)"
    sudo chsh -s "$zsh_path" "$USER"
    print_success "Default shell set to zsh"
}

# ============================================================================
# POST-INSTALL SETUP
# ============================================================================

post_install() {
    print_header "Running post-install setup"

    # Create directories for zsh history
    mkdir -p "$HOME/.local/share/zsh"
    print_success "Created zsh history directory"

    # Install Antidote (will be auto-installed on first zsh launch, but we can do it now)
    if [[ ! -d "$HOME/.local/share/antidote" ]]; then
        print_info "Installing Antidote plugin manager..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.local/share/antidote"
        print_success "Antidote installed"
    else
        print_success "Antidote already installed"
    fi

    # Create success marker file
    touch "$HOME/.config/_SUCCESS"
    print_info "Installation marker created at ~/.config/_SUCCESS"
    
}

# ============================================================================
# MAIN INSTALLATION
# ============================================================================

main() {
    clear
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║         Ultimate Terminal Development Environment          ║"
    echo "║                   Installation Script                      ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"

    print_warning "This script will install and configure:"
    echo "  • WezTerm (terminal emulator)"
    echo "  • Zsh + Antidote (shell + plugin manager)"
    echo "  • Starship (prompt)"
    echo "  • Zellij (terminal multiplexer)"
    echo "  • Neovim + LazyVim (editor)"
    echo "  • Modern CLI tools (eza, bat, fd, etc.)"
    echo ""

    read -p "Continue with installation? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled"
        exit 1
    fi

    # Change to dotfiles directory
    cd "$HOME/.dotfiles" || {
        print_error "Failed to change to ~/.dotfiles directory"
        exit 1
    }

    # Run installation steps
    backup_dotfiles
    install_tools
    stow_dotfiles
    set_default_shell
    post_install

    # Print completion message
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║                  Installation Complete!                    ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    print_success "All tools installed and configured!"
    echo ""
    print_header "Next Steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Launch WezTerm for the first time"
    echo "  3. In WezTerm, start Zellij: zellij"
    echo "  4. Open Neovim to trigger LazyVim installation: nvim"
    echo "  5. Review configurations in ~/.dotfiles/"
    echo ""
    print_info "For machine-specific configs:"
    print_info "  • Zsh: ~/.config/zsh/.zshrc.local"
    print_info "  • Env: ~/.zshenv.local"
    print_info "  • Brew: ~/.config/brew/Brewfile.local"
    print_info "See example files in ~/.dotfiles/ for templates"
    echo ""
    print_info "Use 'make -f ~/.config/Makefile help' to see available management commands"
    echo ""
    print_warning "Note: You may need to restart your terminal for all changes to take effect"
    echo ""

    # Change to back to previous directory
    cd - &> /dev/null
}

# Run main function
main
