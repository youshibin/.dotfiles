# Ultimate Terminal Development Environment

A portable, keyboard-focused terminal development environment optimized for productivity across multiple macOS machines.

## Features

- **WezTerm**: GPU-accelerated terminal emulator with Lua configuration
- **Zsh + Antidote**: Fast shell with modern plugin management (replacing oh-my-zsh)
- **Starship**: Blazing-fast, customizable prompt
- **Zellij**: Modern terminal multiplexer with vim-like keybindings
- **LazyVim**: Pre-configured Neovim distribution for coding
- **Modern CLI Tools**: eza, bat, fd, ripgrep for enhanced productivity
- **GNU Stow**: Elegant dotfile management with symlinks
- **Nerd Fonts**: Icon support across all tools

## Quick Start

### Installation on a New Machine

1. **Clone this repository**
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installation script**
   ```bash
   ./install.sh
   ```
   
   **Note:** The script will prompt for your password (sudo) to change your default shell to zsh.

3. **Restart your terminal or run**
   ```bash
   exec zsh
   ```

4. **Launch WezTerm** and start using your new environment!

## Repository Structure

```
~/.dotfiles/
├── install.sh                   # Installation script
├── .gitignore                   # Git ignore rules
├── README.md                    # This file
│
├── brew/
│   └── .config/brew/
│       ├── Brewfile               # Core Homebrew dependencies
│       └── Brewfile.local.example # Template for machine-specific tools
│
├── make/
│   └── .config/
│       ├── Makefile             # Development environment management
│       └── README.md            # Makefile documentation
│
├── wezterm/
│   └── .config/wezterm/
│       └── wezterm.lua          # WezTerm terminal emulator config
│
├── zsh/
│   ├── .zshenv                  # Environment variables (sourced first)
│   ├── .zshenv.local.example    # Example local environment overrides
│   └── .config/zsh/
│       ├── .zshrc               # Main Zsh config (interactive shells)
│       ├── .zsh_plugins.txt     # Antidote plugin list
│       └── .zshrc.local.example # Example local config overrides
│
├── starship/
│   └── .config/
│       └── starship.toml        # Starship prompt config
│
├── zellij/
│   └── .config/zellij/
│       └── config.kdl           # Zellij multiplexer config
│
└── nvim/
    └── .config/nvim/
        ├── init.lua             # Neovim entry point
        ├── lua/
        │   ├── config/          # Core configuration
        │   │   ├── lazy.lua     # Plugin manager
        │   │   ├── options.lua  # Neovim options
        │   │   └── autocmds.lua # Autocommands
        │   └── plugins/         # Custom plugins
        └── .stylua.toml         # Lua formatter config
```

### XDG Base Directory Compliance

This setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to keep your home directory clean:

- **Configuration**: `~/.config/` - All tool configs live here
- **Data**: `~/.local/share/` - Application data (zsh history, antidote, etc.)
- **Cache**: `~/.cache/` - Temporary cached data

Notable exception: `.zshenv` lives at `~/.zshenv` (zsh requires this location for initial environment setup).

## How GNU Stow Works

GNU Stow creates symlinks from your home directory to files in this repository:

```
~/.dotfiles/wezterm/.config/wezterm/wezterm.lua
                    ↓ (symlink)
~/.config/wezterm/wezterm.lua
```

This means:
- All actual config files live in `~/.dotfiles/` (git-tracked)
- Your home directory only contains symlinks (stays clean)
- Changes are immediately reflected (no need to copy files)

### Managing Dotfiles with Make

Use the Makefile for convenient management:

```bash
# Stow all packages
make -f ~/.config/Makefile stow

# Stow specific packages
make -f ~/.config/Makefile stow PACKAGES="zsh wezterm"

# Unstow packages
make -f ~/.config/Makefile unstow PACKAGES="nvim"

# Verify symlinks
make -f ~/.config/Makefile stow-check

# See all available targets
make -f ~/.config/Makefile help
```

### Manual Stow Commands

```bash
# Install specific config
cd ~/.dotfiles
stow wezterm

# Remove specific config
stow -D wezterm

# Reinstall (useful after updates)
stow -R wezterm

# Install all configs
stow brew make nvim starship wezterm zellij zsh
```

## Machine-Specific Configuration

For machine-specific settings, use local override files (never committed to git):

### Zsh Local Overrides

1. **Copy the example file**
   ```bash
   cp ~/.dotfiles/zsh/.config/zsh/.zshrc.local.example ~/.config/zsh/.zshrc.local
   ```

2. **Edit `~/.config/zsh/.zshrc.local`** with your machine-specific configs
   - Work VPNs, SSH aliases
   - Company-specific environment variables
   - Custom functions and aliases

3. **Never commit `.zshrc.local`** (it's in `.gitignore`)

### Environment Variables Local Overrides

**For PATH and environment variables, use `.zshenv.local`**:

#### Common Environment → `.zshenv` (committed)
Variables that should be on **every machine**:
```bash
# Already configured in ~/.dotfiles/zsh/.zshenv:
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"  # Homebrew
export PATH="$HOME/.local/bin:$PATH"                      # Local binaries
export EDITOR='nvim'
```

#### Machine-Specific Environment → `~/.zshenv.local` (NOT committed)
Variables specific to **this machine only**:

1. **Copy the example file**
   ```bash
   cp ~/.dotfiles/zsh/.zshenv.local.example ~/.zshenv.local
   ```

2. **Edit `~/.zshenv.local`** and add what you need
   ```bash
   # Work Machine Example:
   export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
   export KUBECONFIG="$HOME/.kube/work-cluster-config"
   export AWS_PROFILE="work"

   # Personal Machine Example:
   export ANDROID_HOME="$HOME/Library/Android/sdk"
   export PATH="$PATH:$ANDROID_HOME/platform-tools"
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   ```

3. **Never commit `~/.zshenv.local`** (it's in `.gitignore`)

**Why `.zshenv` vs `.zshrc`?**
- `.zshenv` - Loaded for **all** shells (interactive and non-interactive)
- `.zshrc` - Only loaded for **interactive** shells
- PATH should be in `.zshenv` so scripts and non-interactive shells have access to your tools

### Brewfile Local Overrides

The main `Brewfile` contains only essential terminal tools. For machine-specific development tools, use `Brewfile.local`:

1. **Copy the example file**
   ```bash
   cp ~/.dotfiles/brew/.config/brew/Brewfile.local.example ~/.config/brew/Brewfile.local
   ```

2. **Edit `~/.config/brew/Brewfile.local`** and add the tools you need
   - Language runtimes (Node, Python, Go, Ruby)
   - Container tools (Docker, Kubernetes)
   - Cloud CLIs (AWS, GCP, Azure)
   - Databases (PostgreSQL, Redis, etc.)
   - Work-specific tools

3. **Install the tools**
   ```bash
   make -f ~/.config/Makefile brew-bundle-install
   # Or manually:
   brew bundle install --file=~/.config/brew/Brewfile.local
   ```

4. **Never commit `Brewfile.local`** (it's in `.gitignore`)

**Example - Work Machine**:
```ruby
# ~/.config/brew/Brewfile.local
brew "kubernetes-cli"
brew "helm"
brew "awscli"
brew "postgresql@16"
cask "visual-studio-code"
```

**Example - Personal Machine**:
```ruby
# ~/.config/brew/Brewfile.local
brew "node"
brew "python@3.13"
brew "docker"
brew "docker-compose"
```

**Note**: The `install.sh` script automatically installs from both `Brewfile` and `~/Brewfile.local` if it exists.

## Tool-Specific Documentation

### WezTerm

**Configuration**: `~/.dotfiles/wezterm/.config/wezterm/wezterm.lua`

**Key Features**:
- JetBrainsMono Nerd Font, 16pt
- Tab bar hidden (Zellij handles multiplexing)
- Minimal keybindings (Zellij handles most)

**Customization**:
- Change color scheme: Uncomment themes in `wezterm.lua`
- View all themes: `wezterm ls-fonts --list-schemes`

### Zsh + Antidote

**Configuration**: `~/.dotfiles/zsh/.zshrc`

**Plugins** (defined in `.zsh_plugins.txt`):
- `zsh-autosuggestions` - Fish-like autosuggestions
- `zsh-syntax-highlighting` - Syntax highlighting as you type
- `zsh-completions` - Additional completion definitions
- Oh-My-Zsh plugins: git, colored-man-pages

**Adding Plugins**:
1. Edit `~/.dotfiles/zsh/.zsh_plugins.txt`
2. Add plugin: `username/repo` or `ohmyzsh/ohmyzsh path:plugins/name`
3. Reload: `exec zsh`

**History Search**:
- Type partial command + Up/Down arrow
- Searches commands that START with typed text

### Starship

**Configuration**: `~/.dotfiles/starship/.config/starship.toml`

**Features**:
- Two-line prompt with directory tree
- Git status and branch info
- Language version indicators (auto-detected in projects)
- Command duration for long-running commands
- Color-coded username/hostname

**Customization**:
- Full docs: https://starship.rs/config/
- Explore presets: `starship preset -l`

### Zellij

**Configuration**: `~/.dotfiles/zellij/.config/zellij/config.kdl`

**Modes**:
- **Normal** - Default mode
- **Resize** - Adjust pane sizes (h/j/k/l)
- **Scroll** - Scroll through output
- **Search** - Search scrollback

### Neovim (LazyVim)

**Configuration**: `~/.dotfiles/nvim/.config/nvim/`

**First Launch**:
1. Run `nvim`
2. LazyVim will auto-install plugins (wait for completion)
3. Restart Neovim

**Key Features**:
- Pre-configured LSP, linting, formatting
- File explorer, fuzzy finder, git integration
- Treesitter syntax highlighting
- Auto-completion, snippets

**Adding Plugins**:
1. Create file in `~/.dotfiles/nvim/.config/nvim/lua/plugins/`
2. Follow LazyVim plugin spec
3. Restart Neovim

**Documentation**:
- LazyVim: https://lazyvim.org
- Neovim: https://neovim.io/doc/

## Modern CLI Tools

Installed via Brewfile, configured in `.zshrc`:

| Old Command | Modern Replacement | Description |
|-------------|-------------------|-------------|
| `ls` | `eza` | Colorful, icon-based file listing |
| `cat` | `bat` | Syntax highlighting, git integration |
| `find` | `fd` | Faster, simpler file search |
| `grep` | `ripgrep` (`rg`) | Faster text search |

**Aliases**:
```bash
ls      # eza with icons
la      # eza -la (all files, long format, git status)
ll      # eza -l (long format)
lt      # eza --tree (tree view)
cat     # bat with no paging
```

## Updating Your Dotfiles

### On Your Main Machine

```bash
cd ~/.dotfiles
# Make changes to configs
git add .
git commit -m "Update zsh config"
git push
```

### On Other Machines

```bash
cd ~/.dotfiles
git pull
stow -R wezterm zsh starship zellij nvim  # Re-stow to update symlinks
exec zsh  # Reload shell
```

## Resources

- [WezTerm Docs](https://wezfurlong.org/wezterm/)
- [Starship Docs](https://starship.rs/)
- [Zellij Docs](https://zellij.dev/)
- [LazyVim Docs](https://lazyvim.org/)
- [Antidote Docs](https://getantidote.github.io/)
