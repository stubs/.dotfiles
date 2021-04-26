# source all the dotfiles
for DOTFILE in ~/.functions ~/.aliases ~/.exports ~/.bash_auth; do
    [ -f $DOTFILE ] && source $DOTFILE
done

# Vi mode in bash
set -o vi

# work virtualenvs
# if [ "$HOSTNAME" = "ABT-AG-h03647.local" ]; then
source /usr/local/bin/virtualenvwrapper.sh
# fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/agonzalez/google-cloud-sdk/path.bash.inc' ]; then source '/Users/agonzalez/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/agonzalez/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/agonzalez/google-cloud-sdk/completion.bash.inc'; fi

# home pyenvs
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#haskell
[ -f /Users/stubs/.ghcup/env ] && source /Users/stubs/.ghcup/env

# choose right homebrew
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
  eval $(/usr/local/bin/brew shellenv)
  export SYSTEM_VERSION_COMPAT=1
else
  eval $(/opt/homebrew/bin/brew shellenv)
fi
