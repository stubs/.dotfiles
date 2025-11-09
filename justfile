#!/usr/bin/env -S uvx --from=rust-just just --justfile

set quiet # Recipes are silent by default

# Default recipe (shows help)
default:
    @just --list

# Complete setup - runs everything in order
setup: install-brew \
       install-brewfile \
       install-fonts \
       install-ghostty \
       install-neovim \
       install-npm-lsp-servers \
       install-crush \
       install-fzf \
       deploy-dotfiles \
       setup-shell \
       macos-defaults
    @echo "✅ Setup complete! You may need to restart your terminal."

# Install Homebrew if not already installed
install-brew:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v brew >/dev/null 2>&1; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "✅ Homebrew already installed"
    fi

    # Setup shellenv based on architecture
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
        export SYSTEM_VERSION_COMPAT=1
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    brew update

# Install packages from brewfile (interactive selection)
install-brewfile:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup brew command
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "📦 Which brewfile to install?"
    select yn in "$HOME/home_brewfile" "$HOME/work_brewfile"; do
        case $yn in
            "$HOME/home_brewfile" )
                brew bundle --file="$HOME/home_brewfile" --no-lock
                break
                ;;
            "$HOME/work_brewfile" )
                brew bundle --file="$HOME/work_brewfile" --no-lock
                break
                ;;
        esac
    done

    echo "🧹 Cleaning up old brew packages..."
    brew cleanup
    echo "✅ Brewfile packages installed"

# Install home brewfile non-interactively
install-brewfile-home:
    #!/usr/bin/env bash
    set -euo pipefail

    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "📦 Installing home brewfile..."
    brew bundle --file="$HOME/home_brewfile" --no-lock
    brew cleanup
    echo "✅ Home brewfile installed"

# Install work brewfile non-interactively
install-brewfile-work:
    #!/usr/bin/env bash
    set -euo pipefail

    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "📦 Installing work brewfile..."
    brew bundle --file="$HOME/work_brewfile" --no-lock
    brew cleanup
    echo "✅ Work brewfile installed"

# Download and install Fira Code Nerd Font
install-fonts:
    #!/usr/bin/env bash
    set -euo pipefail

    if compgen -G "$HOME/Library/Fonts/Fira*Nerd*" > /dev/null; then
        echo "✅ Fira Code Nerd Font already installed"
    else
        echo "📥 Downloading and installing Fira Code Nerd Font..."
        curl -JLO 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip'
        mkdir "$HOME"/FiraCode
        unzip FiraCode.zip -d "$HOME"/FiraCode
        cp "$HOME"/FiraCode/* "$HOME"/Library/Fonts/
        rm -r "$HOME"/FiraCode
        rm FiraCode.zip
        echo "✅ Fira Code Nerd Font installed"
    fi

# Download and install Ghostty terminal
install-ghostty:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -d "/Applications/Ghostty.app" ]; then
        echo "✅ Ghostty already installed"
    else
        GHOSTTY_VERSION="1.2.2"
        echo "👻 Downloading and installing Ghostty ${GHOSTTY_VERSION}..."

        # Download the DMG
        echo "  Downloading Ghostty.dmg..."
        curl -fsSL "https://release.files.ghostty.org/${GHOSTTY_VERSION}/Ghostty.dmg" -o /tmp/Ghostty.dmg

        # Mount the DMG
        echo "  Mounting Ghostty.dmg..."
        hdiutil attach /tmp/Ghostty.dmg -quiet

        # Copy the app to /Applications
        echo "  Copying Ghostty.app to /Applications..."
        cp -r /Volumes/Ghostty/Ghostty.app /Applications/

        # Unmount the DMG
        echo "  Unmounting Ghostty.dmg..."
        hdiutil detach /Volumes/Ghostty -quiet

        # Create symlink to /usr/local/bin (requires sudo)
        if [ ! -L /usr/local/bin/ghostty ]; then
            echo "  Creating symlink to /usr/local/bin/ghostty (requires sudo)..."
            sudo ln -sf "/Applications/Ghostty.app/Contents/MacOS/ghostty" /usr/local/bin/ghostty
        fi

        # Clean up
        rm /tmp/Ghostty.dmg

        echo "✅ Ghostty installed"
    fi

# Download and install Neovim
install-neovim:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -d "/usr/local/nvim" ]; then
        echo "✅ Neovim already installed"
    else
        NVIM_VERSION="0.10.3"
        ARCH_NAME="$(uname -m)"

        # Determine architecture-specific download URL
        if [ "${ARCH_NAME}" = "x86_64" ]; then
            NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-macos-x86_64.tar.gz"
            NVIM_DIR="nvim-macos-x86_64"
        else
            NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-macos-arm64.tar.gz"
            NVIM_DIR="nvim-macos-arm64"
        fi

        echo "📝 Downloading and installing Neovim ${NVIM_VERSION}..."

        # Download the tarball
        echo "  Downloading Neovim..."
        curl -fsSL "$NVIM_URL" -o /tmp/nvim-macos.tar.gz

        # Remove "unknown developer" warning on macOS
        echo "  Removing quarantine attribute..."
        xattr -c /tmp/nvim-macos.tar.gz

        # Extract the tarball
        echo "  Extracting Neovim..."
        tar xzf /tmp/nvim-macos.tar.gz -C /tmp

        # Move to /usr/local/nvim (requires sudo)
        echo "  Moving Neovim to /usr/local/nvim (requires sudo)..."
        sudo mv "/tmp/${NVIM_DIR}" /usr/local/nvim

        # Create symlink to /usr/local/bin
        echo "  Creating symlink to /usr/local/bin/nvim..."
        sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

        # Clean up
        rm /tmp/nvim-macos.tar.gz

        echo "✅ Neovim installed"
    fi

# Install NPM language servers for Neovim
install-npm-lsp-servers:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup brew command
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    if [ ! -f nvim/.config/nvim/lua/config/nvim-lspconfig.lua ]; then
        echo "⚠️  nvim-lspconfig.lua not found, skipping NPM language servers"
        exit 0
    fi

    echo "📦 Installing NPM language servers for Neovim..."
    "$(brew --prefix)"/opt/grep/libexec/gnubin/grep -E "npm" nvim/.config/nvim/lua/config/nvim-lspconfig.lua \
        | "$(brew --prefix)"/opt/gnu-sed/libexec/gnubin/sed 's/-- npm i -g //g' \
        | xargs "$(brew --prefix)"/bin/npm i -g

    echo "✅ NPM language servers installed"

# Deploy dotfiles using GNU stow
# WARNING: This will remove existing files/dirs before stowing!
deploy-dotfiles:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup brew command
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🔗 Deploying dotfiles with stow..."
    echo "⚠️  WARNING: This will remove existing dotfiles before stowing!"

    for dir in $(/bin/ls -d */); do
        # Remove files that will be stowed
        for file in $(/usr/bin/find "$dir" -maxdepth 1 -type f -ls | cut -d/ -f3); do
            if [ -f "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
                echo "  Removing: $HOME/$file"
                rm "$HOME/$file" > /dev/null 2>&1 || true
            fi
        done

        # Remove .config subdirs that will be stowed
        for subdir in $("$(brew --prefix)"/opt/coreutils/libexec/gnubin/ls -aR1 --ignore='.git' "$dir" 2>/dev/null | grep -Eo "/\.config/\w+/" | uniq || true); do
            if [ -d "$HOME$subdir" ]; then
                echo "  Removing dir: $HOME$subdir"
                rm -rf "$HOME$subdir" > /dev/null 2>&1 || true
            fi
        done

        # Stow the directory
        DIR_NAME=$(echo "$dir" | cut -d/ -f1)
        echo "  Stowing: $DIR_NAME"
        "$(brew --prefix)"/bin/stow "$DIR_NAME"
    done

    echo "✅ Dotfiles deployed"

# Set Homebrew bash as the default shell
setup-shell:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup brew command
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    BREW_BASH="$(brew --prefix)/bin/bash"

    echo "🐚 Setting up Homebrew bash as default shell..."

    # Add to /etc/shells if not already there
    if ! grep -q "$BREW_BASH" /etc/shells; then
        echo "  Adding $BREW_BASH to /etc/shells (requires sudo)..."
        echo "$BREW_BASH" | sudo tee -a /etc/shells
    fi

    # Change default shell if not already set
    if [ "$SHELL" != "$BREW_BASH" ]; then
        echo "  Changing default shell to $BREW_BASH..."
        chsh -s "$BREW_BASH"
        echo "✅ Default shell changed (restart terminal to apply)"
    else
        echo "✅ Already using Homebrew bash"
    fi

# Install FZF binary from GitHub releases
install-fzf:
    #!/usr/bin/env bash
    set -euo pipefail

    ARCH_NAME="$(uname -m)"
    FZF_VERSION="0.66.0"

    # Determine architecture-specific download URL
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        FZF_URL="https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-darwin_amd64.tar.gz"
    else
        FZF_URL="https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-darwin_arm64.tar.gz"
    fi

    echo "🔍 Installing FZF ${FZF_VERSION}..."

    # Create permanent installation directory
    mkdir -p "$HOME/.local/bin"

    # Download and extract fzf
    echo "  Downloading fzf from GitHub releases..."
    curl -fsSL "$FZF_URL" -o /tmp/fzf.tar.gz

    echo "  Extracting fzf..."
    tar -xzf /tmp/fzf.tar.gz -C "$HOME/.local/bin"
    chmod +x "$HOME/.local/bin/fzf"

    # Create symlink to /usr/local/bin (requires sudo)
    if [ ! -L /usr/local/bin/fzf ]; then
        echo "  Creating symlink to /usr/local/bin/fzf (requires sudo)..."
        sudo ln -sf "$HOME/.local/bin/fzf" /usr/local/bin/fzf
    else
        echo "  Symlink already exists at /usr/local/bin/fzf"
    fi

    # Clean up
    rm /tmp/fzf.tar.gz

    echo "✅ FZF installed to $HOME/.local/bin/fzf"
    echo "✅ Symlinked to /usr/local/bin/fzf"
    echo "ℹ️  Note: Shell keybindings should be configured in your shell config"

# Install Crush binary from GitHub releases
install-crush:
    #!/usr/bin/env bash
    set -euo pipefail

    ARCH_NAME="$(uname -m)"
    CRUSH_VERSION="0.16.1"

    # Determine architecture-specific download URL
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        CRUSH_URL="https://github.com/charmbracelet/crush/releases/download/v${CRUSH_VERSION}/crush_${CRUSH_VERSION}_Darwin_x86_64.tar.gz"
    else
        CRUSH_URL="https://github.com/charmbracelet/crush/releases/download/v${CRUSH_VERSION}/crush_${CRUSH_VERSION}_Darwin_arm64.tar.gz"
    fi

    echo "💖 Installing Crush ${CRUSH_VERSION}..."

    # Create permanent installation directory
    mkdir -p "$HOME/.local/bin"

    # Download and extract crush
    echo "  Downloading crush from GitHub releases..."
    curl -fsSL "$CRUSH_URL" -o /tmp/crush.tar.gz

    echo "  Extracting crush..."
    tar xzf /tmp/crush.tar.gz -C /tmp
    mv /tmp/crush_${CRUSH_VERSION}_Darwin_arm64/crush "$HOME/.local/bin/crush"
    chmod +x "$HOME/.local/bin/crush"

    # Create symlink to /usr/local/bin (requires sudo)
    if [ ! -L /usr/local/bin/crush ]; then
        echo "  Creating symlink to /usr/local/bin/crush (requires sudo)..."
        sudo ln -sf "$HOME/.local/bin/crush" /usr/local/bin/crush
    else
        echo "  Symlink already exists at /usr/local/bin/crush"
    fi

    # Clean up
    rm /tmp/crush.tar.gz

    echo "✅ Crush installed to $HOME/.local/bin/crush"
    echo "✅ Symlinked to /usr/local/bin/crush"

# Apply macOS system defaults
macos-defaults:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ ! -f ./osxdefaults.sh ]; then
        echo "⚠️  osxdefaults.sh not found, skipping"
        exit 0
    fi

    echo "🍎 Applying macOS defaults..."
    ./osxdefaults.sh
    echo "✅ macOS defaults applied"

# Show what the setup will do (dry run)
dry-run:
    @echo "🔍 Dotfiles Setup - What will be done:"
    @echo ""
    @echo "1. 📦 Install Homebrew (if not installed)"
    @echo "2. 📦 Install brewfile (interactive: home or work)"
    @echo "3. 🔧 Install core tools: stow, coreutils, grep, gnu-sed"
    @echo "4. 📥 Install Fira Code Nerd Font"
    @echo "5. 👻 Install Ghostty terminal"
    @echo "6. 📝 Install Neovim from binary"
    @echo "7. 📦 Install NPM language servers for Neovim"
    @echo "8. 🔗 Deploy dotfiles using stow"
    @echo "   ⚠️  WARNING: Removes existing dotfiles before stowing!"
    @echo "9. 🐚 Set Homebrew bash as default shell (requires sudo)"
    @echo "10. 🔍 Install FZF binary"
    @echo "11. 💖 Install Crush binary"
    @echo "12. 🍎 Apply macOS system defaults"
    @echo ""
    @echo "To run full setup: ./justfile setup"
    @echo "To run individual steps: ./justfile <command-name>"
    @echo "To see all commands: ./justfile --list"

# Clean up downloaded files and brew cache
clean:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup brew command
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🧹 Cleaning up..."
    rm -f FiraCode.zip
    rm -f /tmp/Ghostty.dmg
    rm -f /tmp/fzf.tar.gz
    rm -f /tmp/nvim-macos.tar.gz
    brew cleanup
    echo "✅ Cleanup complete"

# Unstow all dotfiles (reverse deployment)
unstow-dotfiles:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup brew command
    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🔗 Unstowing all dotfiles..."
    for dir in $(/bin/ls -d */); do
        DIR_NAME=$(echo "$dir" | cut -d/ -f1)
        echo "  Unstowing: $DIR_NAME"
        "$(brew --prefix)"/bin/stow -D "$DIR_NAME" || true
    done
    echo "✅ Dotfiles unstowed"

# Update all brew packages
update-brew:
    #!/usr/bin/env bash
    set -euo pipefail

    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "📦 Updating Homebrew and packages..."
    brew update
    brew upgrade
    brew cleanup
    echo "✅ Homebrew updated"

# Check brew bundle without installing
check-brewfile:
    #!/usr/bin/env bash
    set -euo pipefail

    ARCH_NAME="$(uname -m)"
    if [ "${ARCH_NAME}" = "x86_64" ]; then
        eval $(/usr/local/bin/brew shellenv)
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🔍 Checking brewfile status..."
    echo ""
    echo "Home brewfile:"
    brew bundle check --file="$HOME/home_brewfile" --verbose || true
    echo ""
    echo "Work brewfile:"
    brew bundle check --file="$HOME/work_brewfile" --verbose || true
