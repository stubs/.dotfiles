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
for DOTFILE in ~/.functions ~/.aliases ~/.exports ~/.bash_auth ~/.bash_work_specific_stuff; do
    [ -f $DOTFILE ] && source $DOTFILE
done

#haskell
[ -f /Users/$USER/.ghcup/env ] && source /Users/$USER/.ghcup/env

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env

[ -f "$(brew --prefix)"/opt/chruby/share/chruby/chruby.sh ] && source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
eval "$(starship init bash)"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/agonzalez/google-cloud-sdk/path.bash.inc' ]; then . '/Users/agonzalez/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/agonzalez/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/agonzalez/google-cloud-sdk/completion.bash.inc'; fi
