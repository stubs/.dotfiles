# Dotfiles

My personal dotfiles for macOS, featuring a modern development environment with Neovim, custom shell configurations, and automated setup.

## 🚀 Quick Start (TL;DR)

**For a brand new Mac:**

```bash
# 1. Clone this repository
git clone <your-repo-url> ~/.dotfiles

# 2. Navigate to the directory
cd ~/.dotfiles

# 3. Run the complete setup (this does everything!)
./setup.sh

# 4. Restart your terminal (or restart your Mac)

# 5. Setup Neovim plugins:
#    a) Edit init.lua and comment out everything after 'require plugins'
#    b) Open plugins.lua to trigger plugin installation:
nvim ~/.config/nvim/lua/plugins.lua
#    c) Wait for plugins to install, then quit
#    d) Uncomment the lines in init.lua
#    e) Restart Neovim
```

That's it! Your development environment is ready.

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [What's Included](#whats-included)
- [Installation](#installation)
  - [Quick Setup (Recommended)](#quick-setup-recommended)
  - [Manual Setup (Individual Steps)](#manual-setup-individual-steps)
- [What the Setup Does](#what-the-setup-does)
- [Available Commands](#available-commands)
- [Post-Installation](#post-installation)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Directory Structure](#directory-structure)

---

## ⚙️ Prerequisites

- **macOS** (this setup is designed for macOS)
- **Stock zsh shell** (default on new Macs)
- **Internet connection** (for downloading dependencies)
- **Admin/sudo access** (for changing default shell)

---

## 📦 What's Included

This dotfiles repository includes:

- **Shell Configuration**: Custom bash setup with aliases, functions, and enhanced CLI tools
- **Neovim**: Fully configured modern text editor with LSP, debugging, and plugins (installed from binary)
- **Ghostty Terminal**: Modern GPU-accelerated terminal emulator
- **FZF**: Fast fuzzy finder for command-line (installed from binary)
- **Starship Prompt**: Fast, customizable shell prompt
- **Git Tools**: Custom git scripts and configurations
- **Homebrew Packages**: Curated lists of CLI tools, applications, and utilities
- **macOS Defaults**: Sensible macOS system preferences
- **GNU Tools**: Modern versions of core utilities (grep, sed, ls, etc.)

---

## 🔧 Installation

### Clone the Repository

From your home directory, clone this repository:

```bash
cd ~
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

**Note**: The repository MUST be cloned to `~/.dotfiles` for the stow symlinks to work correctly.

---

### Quick Setup (Recommended)

**The easiest way to set up everything:**

```bash
./setup.sh
```

**What this does:**

1. ✅ Installs `uv` (required for the justfile to work)
2. ✅ Runs `./justfile setup` which installs everything:
   - Homebrew
   - Core tools (stow, coreutils, grep, gnu-sed)
   - Fonts (Fira Code Nerd Font)
   - Ghostty terminal
   - Neovim
   - NPM language servers
   - Deploys dotfiles with stow
   - Sets up shell
   - Installs FZF
   - Applies macOS defaults

This is a single command that handles the entire setup from start to finish!

---

### Manual Setup (Individual Steps)

If you prefer to run steps individually or need to resume from a specific point:

```bash
# First, install uv (required for justfile to work)
curl -LsSf https://astral.sh/uv/0.9.4/install.sh | env UV_NO_MODIFY_PATH=1 sh
sudo ln -sf "$HOME/.local/bin/uv" /usr/local/bin/uv

# See all available commands
./justfile --list

# See what the setup will do (dry run)
./justfile dry-run

# Run full setup (all steps)
./justfile setup

# Or run individual steps as needed
./justfile install-brew
./justfile install-fonts
./justfile install-ghostty
./justfile install-neovim
./justfile deploy-dotfiles
./justfile install-brewfile-home  # Non-interactive home setup
./justfile install-brewfile-work  # Non-interactive work setup
```

**Benefits of manual setup:**

- ✅ Run individual steps independently
- ✅ Resume from where you left off if interrupted
- ✅ Clear documentation of what each step does
- ✅ Skip steps you don't need
- ✅ Non-interactive options available

---

### Restart Your System

After the setup completes:

1. Close your terminal completely
2. Optionally restart your Mac for all changes to take effect
3. Open a new terminal (it should now be using bash instead of zsh)

### Neovim Plugin Setup

The Neovim plugins require a special initialization process:

```bash
# 1. Open init.lua and comment out everything after 'require("plugins")'
nvim ~/.config/nvim/init.lua
# Add -- before each line after the plugins require statement

# 2. Open plugins.lua to trigger the plugin manager installation
nvim ~/.config/nvim/lua/plugins.lua
# Save the file (:w) and let the plugins install
# You'll see package manager activity in the background
# Wait for installation to complete, then quit (:q)

# 3. Re-open init.lua and uncomment the lines you commented in step 1
nvim ~/.config/nvim/init.lua

# 4. Restart Neovim - everything should now work!
nvim
```

---

## 🔍 What the Setup Does

The `setup.sh` script automates the entire setup process by first installing `uv`, then running `./justfile setup` to complete all remaining steps. Here's a detailed breakdown:

### 0. **UV Installation (setup.sh)**

**The setup.sh script starts by installing uv:**

- Installs `uv` (Python package manager) to your system
- `uv` is required because the justfile uses `uvx` in its shebang
- Symlinks `uv` to `/usr/local/bin/uv` for global access
- Enables running the justfile directly with `./justfile` (no need to install `just` separately)
- Then automatically runs `./justfile setup` to complete the installation

### 1. **Nerd Fonts Installation**

- Checks if FiraCode Nerd Font is already installed
- Downloads FiraCode Nerd Font v2.1.0 from GitHub
- Installs fonts to `~/Library/Fonts/`
- Cleans up temporary files

### 2. **Homebrew Installation**

- Checks if Homebrew is installed
- Installs Homebrew if not present
- Configures appropriate paths for Intel (x86_64) or Apple Silicon (arm64) Macs

### 3. **Essential GNU Tools**

   Installs critical utilities needed for the bootstrap process:

- `stow` - Symlink manager for dotfiles
- `coreutils` - GNU core utilities (better ls, cp, etc.)
- `grep` - GNU grep (more features than BSD grep)
- `gnu-sed` - GNU sed (different syntax than BSD sed)

### 4. **Stow Deployment** ⚠️

- Scans each directory in the dotfiles repo
- **WARNING**: Removes existing files/directories that would conflict with stow
- Uses GNU Stow to create symlinks from ~/.dotfiles/* to ~/
- Files go directly to home directory
- Subdirectories (like `.config`) are preserved in structure
- **This step is destructive** - backup your existing dotfiles first!

### 5. **Alacritty Themes**

- Creates `~/.config/alacritty/themes/` directory
- Downloads Gruvbox dark and light themes

### 6. **Homebrew Bundle**

- Prompts you to select home or work Brewfile
- Installs all packages, apps, and tools defined in the selected Brewfile
- This includes: CLI tools, GUI applications, fonts, VS Code extensions, etc.
- Runs `brew cleanup` to remove old versions

### 7. **Shell Change**

- Adds Homebrew's bash to `/etc/shells` (requires sudo)
- Changes your default shell from zsh to bash
- Uses the modern Homebrew-installed bash (not the old macOS system bash)

### 8. **NPM Language Servers**

- Parses your Neovim LSP config
- Extracts npm-based language server requirements
- Installs them globally via npm
- Provides LSP support for TypeScript, JavaScript, etc.

### 9. **Ghostty Terminal**

- Downloads Ghostty v1.2.2 from official releases
- Installs to `/Applications`
- Creates symlink to `/usr/local/bin/ghostty` for CLI access

### 10. **Neovim Installation**

- Downloads Neovim v0.10.3 from GitHub releases
- Detects your Mac architecture (Apple Silicon or Intel)
- Installs to `/usr/local/nvim`
- Creates symlink to `/usr/local/bin/nvim`
- Removes quarantine attributes to avoid "unknown developer" warnings

### 11. **FZF Installation**

- Downloads FZF v0.66.0 binary from GitHub releases
- Installs to `~/.local/bin/fzf`
- Creates symlink to `/usr/local/bin/fzf`
- Note: Shell keybindings need to be configured separately in your shell config

### 12. **macOS Defaults**

- Runs `osxdefaults.sh` script
- Sets sensible macOS system preferences
- Customizes Finder, Dock, and other system behaviors

---

## 🎯 Available Commands

The `justfile` provides these individual commands:

```bash
./justfile                         # Show all available commands
./justfile --list                  # Same as above
./justfile dry-run                 # See what the setup will do without running it

# Setup Commands
./justfile setup                   # Run complete setup (all steps)
./justfile install-brew            # Install Homebrew only
./justfile install-brewfile        # Install brewfile (interactive prompt)
./justfile install-brewfile-home   # Install home brewfile (non-interactive)
./justfile install-brewfile-work   # Install work brewfile (non-interactive)
./justfile install-core-tools      # Install stow, coreutils, grep, gnu-sed
./justfile install-fonts           # Install Fira Code Nerd Font
./justfile install-ghostty         # Install Ghostty terminal
./justfile install-neovim          # Install Neovim from binary
./justfile install-npm-lsp-servers # Install NPM language servers for Neovim
./justfile deploy-dotfiles         # Deploy dotfiles with stow (⚠️ removes existing files)
./justfile setup-shell             # Set Homebrew bash as default shell
./justfile setup-fzf               # Install FZF binary
./justfile macos-defaults          # Apply macOS system defaults

# Maintenance Commands
./justfile update-brew             # Update all Homebrew packages
./justfile check-brewfile          # Check brewfile status without installing
./justfile clean                   # Clean up downloaded files and brew cache
./justfile unstow-dotfiles         # Remove all stow symlinks (reverse deployment)
```

**Common Workflows:**

```bash
# New machine setup (one command does everything!)
./setup.sh

# Update dotfiles on existing machine
./justfile deploy-dotfiles

# Add new packages to brewfile, then install them
./justfile install-brewfile-home

# Update all packages
./justfile update-brew

# Remove dotfiles before switching to different config
./justfile unstow-dotfiles
```

---

## 🎨 Post-Installation

After completing the installation and restarting:

### Verify Installation

```bash
# Check that bash is your default shell
echo $SHELL
# Should output: /opt/homebrew/bin/bash (or /usr/local/bin/bash on Intel)

# Check that stow worked
ls -la ~ | grep -E "\.bashrc|\.aliases"
# You should see symlinks pointing to ~/.dotfiles/

# Test Neovim
nvim --version
# Should show Neovim version info
```

### Configure Git

Don't forget to set up your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Explore Your New Setup

- **Shell**: Your terminal now uses bash with custom aliases and functions
- **Aliases**: Type `alias` to see all custom shortcuts defined in `shell/.aliases`
- **Neovim**: Launch with `nvim` - explore the leader key mappings (likely `<space>`)
- **Starship**: Your prompt is now powered by Starship with rich Git info
- **FZF**: Press `Ctrl+R` for fuzzy command history search

---

## 🎯 Customization

### Modifying Configurations

Since all dotfiles are symlinked, you can edit them in place:

```bash
# Edit shell aliases
nvim ~/.aliases  # Actually editing ~/.dotfiles/shell/.aliases

# Edit Neovim config
nvim ~/.config/nvim/init.lua  # Actually editing ~/.dotfiles/nvim/.config/nvim/init.lua
```

Changes are automatically reflected in the git repository!

### Adding New Packages

To add new Homebrew packages:

```bash
# Edit the appropriate Brewfile
nvim ~/.dotfiles/brewfiles/home_brewfile  # or work_brewfile

# Add packages under the appropriate section:
# brew "package-name"        # for CLI tools
# cask "app-name"           # for GUI applications
# mas "App Name", id: 123   # for Mac App Store apps

# Install the new packages
brew bundle --file=~/home_brewfile
```

### Adding New Dotfiles

To add a new directory to your dotfiles:

```bash
cd ~/.dotfiles
mkdir new-tool
# Add your config files to new-tool/
# Run bootstrap.sh again, or manually stow:
stow new-tool
```

---

## 🐛 Troubleshooting

### Setup Script Fails

**Problem**: Script exits with errors

**Solutions**:

- Ensure you have an internet connection
- Check you have enough disk space
- Make sure you have admin privileges (sudo access)
- Try running individual commands to isolate the issue:

  ```bash
  ./justfile install-brew
  ./justfile install-core-tools
  # etc...
  ```

- If `setup.sh` fails during the uv installation, you may need to manually install `uv` first

### Stow Conflicts

**Problem**: "WARNING: in stow directory, stow conflicts with existing target"

**Solution**:

```bash
# Manually remove the conflicting file
rm ~/.conflicting-file
# Run deploy again
./justfile deploy-dotfiles
```

### Homebrew Permission Issues

**Problem**: Permission denied errors during `brew install`

**Solutions**:

```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) $(brew --prefix)/*
```

### Neovim Plugins Not Loading

**Problem**: Neovim opens but plugins don't work

**Solutions**:

1. Make sure you followed the Neovim plugin setup steps exactly
2. Try manually installing the plugin manager:

   ```bash
   # For lazy.nvim (most common)
   git clone https://github.com/folke/lazy.nvim.git \
     ~/.local/share/nvim/lazy/lazy.nvim
   ```

3. Open Neovim and check for errors: `:checkhealth`
4. Reinstall plugins: `:Lazy sync`

### Shell Still Using zsh

**Problem**: Terminal still opens with zsh after restart

**Solutions**:

1. Manually change shell:

   ```bash
   chsh -s $(brew --prefix)/bin/bash
   ```

2. Restart terminal completely (not just new tab)
3. Check System Preferences → Users & Groups → Advanced Options

### Language Servers Not Working

**Problem**: Neovim LSP features not working

**Solutions**:

```bash
# Reinstall npm language servers
cd ~/.dotfiles
grep -E "npm" nvim/.config/nvim/lua/config/nvim-lspconfig.lua | \
  sed 's/-- npm i -g //g' | \
  xargs npm i -g

# Check LSP status in Neovim
:LspInfo
```

---

## 📁 Directory Structure

```text
~/.dotfiles/
├── setup.sh                 # Complete setup script (run this!)
├── justfile                 # Modern task runner with all setup commands
├── osxdefaults.sh          # macOS system preferences
├── README.md               # This file
├── bootstrap.sh            # [DEPRECATED] Legacy installation script
├── brewfiles/              # Homebrew package definitions
│   ├── home_brewfile      # Personal machine packages
│   └── work_brewfile      # Work machine packages
├── git/                    # Git configurations and scripts
│   └── better-branch.sh   # Custom git utilities
├── nvim/                   # Neovim configuration
│   └── .config/nvim/
│       ├── init.lua       # Main Neovim config
│       └── lua/           # Lua modules and plugins
├── scripts/                # Custom utility scripts
├── sesh/                   # Session management configs
├── shell/                  # Shell configurations
│   ├── .aliases          # Command aliases
│   ├── .bashrc           # Bash configuration
│   └── .config/          # Shell-related configs
├── starship/               # Starship prompt config
└── vim/                    # Vim configuration (if used)
```

---

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:

- Fork it and adapt it to your needs
- Submit issues if you find bugs
- Suggest improvements via pull requests

---

## 📝 Notes

- **One Command Setup**: Simply run `./setup.sh` for complete installation - it handles everything including uv installation and running the justfile
- **No Just Installation Needed**: The justfile uses `uvx` in its shebang to automatically fetch and run `just`, so you don't need to install it separately
- **Backup First**: If you have existing dotfiles, back them up before running setup - the deploy step removes conflicting files!
- **Review Brewfiles**: Check the Brewfile contents before installation - they install a lot of software
- **Internet Required**: Initial setup downloads several GB of tools and applications
- **Time Required**: First-time setup takes 30-60 minutes depending on your internet speed
- **Shell Change**: The setup changes your shell to bash - if you prefer zsh, skip that step or use individual justfile commands instead of setup.sh
- **Bootstrap.sh Deprecated**: The original `bootstrap.sh` script is deprecated in favor of the streamlined `setup.sh` workflow

---

## 🔗 Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Neovim Documentation](https://neovim.io/doc/)
- [Homebrew Documentation](https://docs.brew.sh/)
- [Starship Configuration](https://starship.rs/config/)

---

**Last Updated**: October 2025
