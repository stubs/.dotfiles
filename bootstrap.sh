#!/usr/bin/env bash


# download nerd font
compgen -G "$HOME/Library/Fonts/Fira*Nerd*" > /dev/null \
|| \
curl -JLO 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip' \
  && mkdir "$HOME"/FiraCode \
  && unzip FiraCode.zip -d "$HOME"/FiraCode \
  && cp "$HOME"/FiraCode/* "$HOME"/Library/Fonts/ \
  && rm -r "$HOME"/FiraCode \
  && rm FiraCode.zip


# Install Homebrew if not installed.
command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew Now"; \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; }

ARCH_NAME="$(uname -m)"
if [ "${ARCH_NAME}" = "x86_64" ]; then
  eval $(/usr/local/bin/brew shellenv)
  export SYSTEM_VERSION_COMPAT=1
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


brew update
command -v "$(brew --prefix)"/bin/stow >/dev/null 2>&1 || brew install stow
command -v "$(brew --prefix)"/opt/coreutils/libexec/gnubin/ls >/dev/null 2>&1 || brew install coreutils
command -v "$(brew --prefix)"/opt/grep/libexec/gnubin/grep >/dev/null 2>&1 || brew install grep
command -v "$(brew --prefix)"/opt/gnu-sed/libexec/gnubin/sed >/dev/null 2>&1 || brew install gnu-sed


# rm stow targets & stow deploy
for dir in $(/bin/ls -d */)
do
    # files in dirs will just be copied (aka stowed) to the home dir.
    # subdirs in each dir will also be copied (aka stowed) to the $HOME/subdir.... eg. dir/.config => $HOME/.config
    for file in $(/usr/bin/find "$dir" -maxdepth 1 -type f -ls | cut -d/ -f3)
    do
	echo "removing if in your ~ directory: $HOME/$file"
        rm "$HOME/$file" > /dev/null 2>&1
    done
    # rm .config/<subdir> prior to stowing
    for subdir in $("$(brew --prefix)"/opt/coreutils/libexec/gnubin/ls -aR1 --ignore='.git' "$dir" | grep -Eo "/\.config/\w+/" | uniq)
    do
	echo "removing dir if in your ~ directory: $HOME$subdir"
        rm "$HOME$subdir" > /dev/null 2>&1
    done
    echo "$dir" | cut -d/ -f1 | xargs -I{} "$(brew --prefix)"/bin/stow {}
done


# Alacritty themes I like:
mkdir -p ~/.config/alacritty/themes/themes/
curl -o .config/alacritty/themes/themes/gruvbox_dark.toml  https://raw.githubusercontent.com/alacritty/alacritty-theme/refs/heads/master/themes/gruvbox_dark.toml
curl -o .config/alacritty/themes/themes/gruvbox_light.toml  https://raw.githubusercontent.com/alacritty/alacritty-theme/refs/heads/master/themes/gruvbox_light.toml


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


# use bash
echo "Adding homebrew's bash to /etc/shells... "
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
echo "Changing default shell to bash... "
chsh -s "$(brew --prefix)"/bin/bash


# npm language servers
"$(brew --prefix)"/opt/grep/libexec/gnubin/grep -E "npm" nvim/.config/nvim/lua/config/nvim-lspconfig.lua | "$(brew --prefix)"/opt/gnu-sed/libexec/gnubin/sed 's/-- npm i -g //g' | xargs "$(brew --prefix)"/bin/npm i -g


# fzf keybindings and fuzzy comp
"$(brew --prefix)"/opt/fzf/install


# macosx defaults
./osxdefaults.sh
