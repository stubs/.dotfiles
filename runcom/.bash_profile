# source all the dotfiles
for DOTFILE in ~/.functions ~/.aliases ~/.exports ~/.bash_auth; do
    [ -f $DOTFILE ] && source $DOTFILE
done

# Vi mode in bash
set -o vi

# Virtualenvwrapper stuff
[ ! "$HOSTNAME" = "ABT-AG-h03647.local" ] && export WORKON_HOME=$HOME/.virtualenvs && export PROJECT_HOME=$HOME/dev/python/
[ "$HOSTNAME" = "ABT-AG-h03647.local" ] && export WORKON_HOME=$HOME/.virtualenvs && export PROJECT_HOME=$HOME/titan
# Use what ever is the pyenv global python
[ ! "$HOSTNAME" = "ABT-AG-h03647.local" ] && export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
[ "$HOSTNAME" = "ABT-AG-h03647.local" ] && export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
source /usr/local/bin/virtualenvwrapper.sh

# pyenv
#[ ! "$HOSTNAME" = "ABT-AG-h03647.local" ] && eval "$(pyenv init -)"

# pyenv-virtualenv
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/agonzalez/google-cloud-sdk/path.bash.inc' ]; then source '/Users/agonzalez/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/agonzalez/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/agonzalez/google-cloud-sdk/completion.bash.inc'; fi
