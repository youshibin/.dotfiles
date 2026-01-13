# ============================================================================
# Makefile - Development Environment Management
# ============================================================================
# This Makefile provides convenient targets for managing your dotfiles,
# Homebrew packages, and shell configuration.
# ============================================================================

.PHONY: help

# Default target - show help
help:
	@echo "Available targets:"
	@echo ""
	@echo "Homebrew Management:"
	@echo "  make brew                - Install Homebrew if not present"
	@echo "  make brew-bundle         - Run brew bundle if Brewfile changed"
	@echo "  make brew-bundle-install - Force brew bundle install"
	@echo "  make brew-bundle-upgrade - Upgrade packages via brew bundle"
	@echo ""
	@echo "Shell Configuration:"
	@echo "  make source              - Source ~/.config/zsh/.zshrc"
	@echo "  make source-local        - Source ~/.config/zsh/.zshrc.local"
	@echo ""
	@echo "Stow Management:"
	@echo "  make stow                - Stow all packages"
	@echo "  make stow PACKAGES=\"...\" - Stow specific packages (space-separated)"
	@echo "  make unstow              - Unstow all packages"
	@echo "  make unstow PACKAGES=\"...\" - Unstow specific packages"
	@echo "  make stow-check          - Verify symlinks for all packages"
	@echo "  make stow-check PACKAGES=\"...\" - Check specific packages"
	@echo ""

# ============================================================================
# CONFIGURATION
# ============================================================================

DOTFILES_DIR := $(HOME)/.dotfiles
CONFIG_DIR := $(HOME)/.config
INSTALL_MARKER := $(CONFIG_DIR)/_SUCCESS

# Conditional brew directory based on installation state
ifeq ($(wildcard $(INSTALL_MARKER)),)
    # Pre-installation: use source brew directory
    BREW_DIR := $(DOTFILES_DIR)/brew/.config/brew
else
    # Post-installation: use stowed symlink
    BREW_DIR := $(CONFIG_DIR)/brew
endif

# Derive Brewfile paths from BREW_DIR
BREWFILE := $(BREW_DIR)/Brewfile
BREWFILE_LOCAL := $(BREW_DIR)/Brewfile.local

ZSHRC := $(CONFIG_DIR)/zsh/.zshrc
ZSHRC_LOCAL := $(CONFIG_DIR)/zsh/.zshrc.local

# All packages that can be stowed
ALL_PACKAGES := brew make nvim starship wezterm zellij zsh

# Default to all packages if PACKAGES not specified
PACKAGES ?= $(ALL_PACKAGES)

# ============================================================================
# HOMEBREW MANAGEMENT
# ============================================================================

# `make brew` installs homebrew if it hasn't already been installed
.PHONY: brew
brew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "Homebrew is already installed."; \
	fi

# `make brew-bundle` runs `brew bundle` if there are git differences with Brewfile
# or if Brewfile.local has been modified
.PHONY: brew-bundle
brew-bundle: brew
	@changed=false; \
	if ! git -C $(DOTFILES_DIR) diff --quiet -- brew/.config/brew/Brewfile; then \
		changed=true; \
	fi; \
	if [ -f "$(BREWFILE_LOCAL)" ] && [ "$(BREWFILE_LOCAL)" -nt "$(BREWFILE)" ]; then \
		changed=true; \
	fi; \
	if [ "$$changed" = false ]; then \
		echo "No changes detected in Brewfile or Brewfile.local."; \
		exit 0; \
	fi; \
	echo "Running brew bundle..."; \
	brew bundle --file $(BREWFILE); \
	if [ -f "$(BREWFILE_LOCAL)" ]; then \
		echo "Installing from Brewfile.local..."; \
		brew bundle install --file $(BREWFILE_LOCAL); \
	fi

# `make brew-bundle-install` runs `brew bundle install`
.PHONY: brew-bundle-install
brew-bundle-install: brew
	@echo "Running brew bundle install..."; \
	brew bundle install --file $(BREWFILE); \
	if [ -f "$(BREWFILE_LOCAL)" ]; then \
		echo "Installing from Brewfile.local..."; \
		brew bundle install --file $(BREWFILE_LOCAL); \
	fi

# `make brew-bundle-upgrade` runs `brew bundle upgrade`
.PHONY: brew-bundle-upgrade
brew-bundle-upgrade: brew
	@echo "Running brew bundle upgrade..."; \
	brew bundle --file $(BREWFILE) || brew bundle upgrade --file $(BREWFILE)
	if [ -f "$(BREWFILE_LOCAL)" ]; then \
		echo "Upgrading from Brewfile.local..."; \
		brew bundle upgrade --file $(BREWFILE_LOCAL); \
	fi

# ============================================================================
# SHELL CONFIGURATION
# ============================================================================

# `make source` sources the main zshrc
.PHONY: source
source:
	@if [ -f "$(ZSHRC)" ]; then \
		echo "Sourcing $(ZSHRC)..."; \
		zsh -c "source $(ZSHRC) && echo 'Successfully sourced .zshrc'"; \
	else \
		echo "Error: $(ZSHRC) not found"; \
		exit 1; \
	fi

# `make source-local` sources the local zshrc overrides
.PHONY: source-local
source-local:
	@if [ -f "$(ZSHRC_LOCAL)" ]; then \
		echo "Sourcing $(ZSHRC_LOCAL)..."; \
		zsh -c "source $(ZSHRC_LOCAL) && echo 'Successfully sourced .zshrc.local'"; \
	else \
		echo "Error: $(ZSHRC_LOCAL) not found"; \
		echo "Create it from the example: cp $(DOTFILES_DIR)/zsh/.config/zsh/.zshrc.local.example $(ZSHRC_LOCAL)"; \
		exit 1; \
	fi

# ============================================================================
# STOW MANAGEMENT
# ============================================================================

# `make stow` stows all packages (or specific packages via PACKAGES variable)
.PHONY: stow
stow:
	@cd $(DOTFILES_DIR) && \
	for package in $(PACKAGES); do \
		echo "Stowing $$package..."; \
		stow -v $$package 2>&1 | grep -v "^BUG in find_stowed_path" || true; \
		echo "✓ $$package stowed"; \
	done

# `make unstow` unstows all packages (or specific packages via PACKAGES variable)
.PHONY: unstow
unstow:
	@cd $(DOTFILES_DIR) && \
	for package in $(PACKAGES); do \
		echo "Unstowing $$package..."; \
		stow -D -v $$package 2>&1 | grep -v "^BUG in find_stowed_path" || true; \
		echo "✓ $$package unstowed"; \
	done

# `make stow-check` verifies that symlinks exist for packages
.PHONY: stow-check
stow-check:
	@echo "Checking stow symlinks..."
	@cd $(DOTFILES_DIR) && \
	all_good=true; \
	for package in $(PACKAGES); do \
		echo "Checking $$package..."; \
		case $$package in \
			wezterm) \
				if [ -L "$(HOME)/.config/wezterm/wezterm.lua" ]; then \
					echo "  ✓ wezterm symlink exists"; \
				else \
					echo "  ✗ wezterm symlink missing"; \
					all_good=false; \
				fi \
				;; \
			zsh) \
				if [ -L "$(HOME)/.config/zsh/.zshrc" ]; then \
					echo "  ✓ zsh symlinks exist"; \
				else \
					echo "  ✗ zsh symlinks missing"; \
					all_good=false; \
				fi \
				;; \
			starship) \
				if [ -L "$(HOME)/.config/starship.toml" ]; then \
					echo "  ✓ starship symlink exists"; \
				else \
					echo "  ✗ starship symlink missing"; \
					all_good=false; \
				fi \
				;; \
			zellij) \
				if [ -L "$(HOME)/.config/zellij/config.kdl" ]; then \
					echo "  ✓ zellij symlink exists"; \
				else \
					echo "  ✗ zellij symlink missing"; \
					all_good=false; \
				fi \
				;; \
			nvim) \
				if [ -L "$(HOME)/.config/nvim/init.lua" ]; then \
					echo "  ✓ nvim symlink exists"; \
				else \
					echo "  ✗ nvim symlink missing"; \
					all_good=false; \
				fi \
				;; \
			make) \
				if [ -L "$(HOME)/.config/Makefile" ]; then \
					echo "  ✓ make symlink exists"; \
				else \
					echo "  ✗ make symlink missing"; \
					all_good=false; \
				fi \
				;; \
			brew) \
				if [ -L "$(HOME)/.config/brew/Brewfile" ]; then \
					echo "  ✓ brew symlink exists"; \
				else \
					echo "  ✗ brew symlink missing"; \
					all_good=false; \
				fi \
				;; \
		esac; \
	done; \
	if [ "$$all_good" = true ]; then \
		echo ""; \
		echo "✓ All symlinks verified successfully!"; \
	else \
		echo ""; \
		echo "✗ Some symlinks are missing. Run 'make stow' to create them."; \
		exit 1; \
	fi