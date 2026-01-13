# Makefile for Development Environment Management

This Makefile provides convenient targets for managing your terminal development environment, including Homebrew packages, GNU Stow symlinks, and shell configuration.

## Location

After stowing, this Makefile is symlinked to `~/.config/Makefile`, allowing you to run make targets from anywhere using:

```bash
make -f ~/.config/Makefile <target>
```

## Quick Reference

### Display Available Targets
```bash
make -f ~/.config/Makefile help
```

## Homebrew Management

### Install Homebrew
```bash
make -f ~/.config/Makefile brew
```
Installs Homebrew if not already present on the system.

### Brew Bundle (Smart)
```bash
make -f ~/.config/Makefile brew-bundle
```
Runs `brew bundle` only if the Brewfile has been modified (checks git diff).

### Brew Bundle Install (Force)
```bash
make -f ~/.config/Makefile brew-bundle-install
```
Forces `brew bundle install` regardless of git status.

### Brew Bundle Upgrade
```bash
make -f ~/.config/Makefile brew-bundle-upgrade
```
Upgrades all packages defined in the Brewfile.

## Shell Configuration

### Source Main Zsh Config
```bash
make -f ~/.config/Makefile source
```
Sources `~/.config/zsh/.zshrc` in a new zsh subshell. Useful for testing configuration changes.

### Source Local Zsh Config
```bash
make -f ~/.config/Makefile source-local
```
Sources `~/.config/zsh/.zshrc.local` (machine-specific overrides).

## Stow Management

GNU Stow creates symlinks from your `~/.dotfiles/` to the appropriate locations in your home directory.

### Stow All Packages
```bash
make -f ~/.config/Makefile stow
```
Stows all packages.

### Stow Specific Packages
```bash
make -f ~/.config/Makefile stow PACKAGES="zsh wezterm"
```
Stows only the specified packages (space-separated list).

### Unstow All Packages
```bash
make -f ~/.config/Makefile unstow
```
Removes symlinks for all packages.

### Unstow Specific Packages
```bash
make -f ~/.config/Makefile unstow PACKAGES="zsh wezterm"
```
Removes symlinks for only the specified packages.

### Check Symlinks
```bash
make -f ~/.config/Makefile stow-check
```
Verifies that all expected symlinks exist for all packages. Returns error if any are missing.

### Check Specific Packages
```bash
make -f ~/.config/Makefile stow-check PACKAGES="zsh nvim"
```
Verifies symlinks for only the specified packages.

## Common Workflows

### After Editing Brewfile
```bash
make -f ~/.config/Makefile brew-bundle
```

### After Pulling Dotfiles Updates
```bash
make -f ~/.config/Makefile stow
make -f ~/.config/Makefile source
```

### Setting Up a New Machine
```bash
# Use the install.sh script instead
cd ~/.dotfiles
./install.sh
```

### Adding a New Tool Package
1. Add the tool to Brewfile
2. Create a new stow package directory
3. Add package name to `ALL_PACKAGES` in the Makefile
4. Run `make stow PACKAGES="newtool"`

## Available Packages

The following packages are available for stow management:
- **brew**: Brewfile for package management
- **make**: This Makefile itself
- **nvim**: Neovim/LazyVim configuration
- **starship**: Prompt configuration
- **wezterm**: Terminal emulator configuration
- **zellij**: Terminal multiplexer configuration
- **zsh**: Shell configuration and plugins

## Implementation Details

### Installation State Marker

The Makefile uses a marker file (`~/.config/_SUCCESS`) to track installation state and determine the correct path to configuration files:

**Before Installation** (`_SUCCESS` doesn't exist):
- Makefile references files in `~/.dotfiles/` directly (source files)
- This allows `./install.sh` to work before stow creates symlinks

**After Installation** (`_SUCCESS` exists):
- Makefile references files in `~/.config/` (stowed symlinks)
- Normal workflow using stowed configuration

The marker is created automatically when `./install.sh` completes successfully. You can remove it to reset the installation state, but this is rarely needed.

### Backup Directory

Installation backups are stored in `~/.config/backups/TIMESTAMP/` to keep your dotfiles repository clean and separate machine-specific state from source-controlled configurations.

