#!/usr/bin/env bash


# download nerd font
compgen -G "$HOME/Library/Fonts/Fira*Nerd*" > /dev/null \
|| \
curl -JLO 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip' \
  && mkdir "$HOME"/FiraCode \
  && unzip FiraCode.zip -d "$HOME"/FiraCode \
  && cp "$HOME"/FiraCode/* "$HOME"/Library/Fonts/ \
  && rm -r "$HOME"/FiraCode


# Install Homebrew if not installed.
command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew Now"; \
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }
brew update
command -v stow >/dev/null 2>&1 || brew install stow


# stow deploy
for dir in $(/bin/ls -d */)
do
    echo "$dir" | cut -d/ -f1 | xargs -I{} stow {}
done


# Install all dependencies. Make sure that the ./runcom/Brewfile is symlinked to ~/
echo "Which brewfile to bundle install?"
select yn in "$HOME/home_brewfile" "$HOME/work_brewfile"; do
  case $yn in
    "$HOME/home_brewfile" ) brew bundle --file="$HOME/home_brewfile" --no-lock; break;;
    "$HOME/work_brewfile" ) brew bundle --file="$HOME/work_brewfile" --no-lock; break;;
  esac
done


# Remove outdated versions from the cellar.
brew cleanup


# npm language servers
grep -E "npm" nvim/.config/nvim/lua/config/nvim-lspconfig.lua | sed 's/-- npm i -g //g' | xargs npm i -g
