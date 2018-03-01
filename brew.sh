!#/usr/bin/env bash

# Install CLI tools using Homebrew.

# Install Homebrew if not installed.
command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew Now"; \
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

# Make sure using the lastest version of Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install all dependencies. Make sure that the ./runcom/Brewfile is symlinked to ~/
brew bundle

# Remove outdated versions from the cellar.
brew cleanup
