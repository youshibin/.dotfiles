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

    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    local files=(".zshrc" ".zshenv" ".config/wezterm" ".config/starship.toml" ".config/zellij" ".config/nvim")

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
# INSTALL HOMEBREW
# ============================================================================

install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew already installed"
        return
    fi

    print_header "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
}

# ============================================================================
# INSTALL TOOLS VIA BREWFILE
# ============================================================================

install_tools() {
    print_header "Installing tools via Brewfile"

    cd "$HOME/.dotfiles" || exit 1

    if [[ ! -f "Brewfile" ]]; then
        print_error "Brewfile not found!"
        exit 1
    fi

    print_info "Running: brew bundle install"
    brew bundle install

    print_success "Core tools installed from Brewfile"

    # Install from local Brewfile if it exists
    if [[ -f "$HOME/Brewfile.local" ]]; then
        print_info "Found Brewfile.local, installing machine-specific tools..."
        brew bundle install --file="$HOME/Brewfile.local"
        print_success "Machine-specific tools installed from Brewfile.local"
    else
        print_info "No Brewfile.local found (optional)"
        print_info "To add machine-specific tools, copy Brewfile.local.example to ~/Brewfile.local"
    fi

    cd - > /dev/null
}

# ============================================================================
# STOW DOTFILES
# ============================================================================

stow_dotfiles() {
    print_header "Symlinking dotfiles with GNU Stow"

    cd "$HOME/.dotfiles" || exit 1

    local packages=("wezterm" "zsh" "starship" "zellij" "nvim")

    for package in "${packages[@]}"; do
        print_info "Stowing $package..."
        stow -v "$package" 2>&1 | grep -v "^BUG in find_stowed_path" || true
        print_success "$package stowed"
    done

    cd - > /dev/null
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

    # Run installation steps
    backup_dotfiles
    install_homebrew
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
    print_info "For machine-specific configs, create ~/.zshrc.local"
    print_info "See ~/.dotfiles/zsh/.zshrc.local.example for examples"
    echo ""
    print_warning "Note: You may need to restart your terminal for all changes to take effect"
    echo ""
}

# Run main function
main
