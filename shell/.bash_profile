# choose right homebrew
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
  eval $(/usr/local/bin/brew shellenv)
  export SYSTEM_VERSION_COMPAT=1
else
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# Vi mode in bash
set -o vi

# source all the dotfiles
for DOTFILE in ~/.functions ~/.aliases ~/.exports ~/.bash_auth; do
    [ -f $DOTFILE ] && source $DOTFILE
done

# haskell
[ -f /Users/$USER/.ghcup/env ] && source /Users/$USER/.ghcup/env

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env

# starship prompt
eval "$(starship init bash)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/Users/$USER/google-cloud-sdk/path.bash.inc" ]; then . "/Users/$USER/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/Users/$USER/google-cloud-sdk/completion.bash.inc" ]; then . "/Users/$USER/google-cloud-sdk/completion.bash.inc"; fi
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
