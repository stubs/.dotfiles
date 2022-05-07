#!/usr/bin/env bash


# download nerd font
compgen -G "~/Library/Fonts/Fira*Nerd*" > /dev/null \
|| \
curl -JLO 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip' \
  && mkdir ~/FiraCode \
  && unzip FiraCode.zip -d ~/FiraCode \
  && cp ~/FiraCode/* ~/Library/Fonts/ \
  && rm -r ~/FiraCode


# Install Homebrew if not installed.
command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew Now"; \
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }
brew update
command -v stow >/dev/null 2>&1 || brew install stow


# stow deploy
for dir in $(/bin/ls -d */)
do
    echo $dir | cut -d/ -f1 | xargs -I{} stow {}
done


# Install all dependencies. Make sure that the ./runcom/Brewfile is symlinked to ~/
echo "Which brewfile to bundle install?"
select yn in "~/home_brewfile" "~/work_brewfile"; do
    case $yn in
        "~/home_brewfile" ) brew bundle --file="~/home_brewfile" --no-lock; break;;
        "~/work_brewfile" ) brew bundle --file="~/work_brewfile" --no-lock; break;;
    esac
done


# Remove outdated versions from the cellar.
brew cleanup


# npm language servers
grep -E "npm" nvim/.config/nvim/lua/config/nvim-lspconfig.lua | sed 's/-- npm i -g //g' | xargs npm i -g
