# source all the dotfiles
for DOTFILE in ~/.functions ~/.aliases ~/.exports ~/.bash_auth; do
    [ -f $DOTFILE ] && source $DOTFILE
done

# Vi mode in bash
set -o vi

source /usr/local/bin/virtualenvwrapper.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/agonzalez/google-cloud-sdk/path.bash.inc' ]; then source '/Users/agonzalez/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/agonzalez/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/agonzalez/google-cloud-sdk/completion.bash.inc'; fi
