#!/bin/bash
############################
# .makesymlinks.sh
# Script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles/runcom
############################

dir=~/.dotfiles/runcom                                                  # dotfiles directory
olddir=~/.dotfiles_old                                                  # old dotfiles backup directory
dot_files="bash_profile inputrc vimrc functions gitconfig aliases exports"      # list of files/folders to symlink in homedir
# sup_files=""                                                          # list of supplemental files to symlink in homedir

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing non-symlink dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $dot_files; do
    [ -e ~/.$file ] && [ ! -h ~/.$file ] && mv ~/.$file $olddir;
    echo "Creating symlink to $file in home directory if needed."
    [ -h ~/.$file ] || ln -s $dir/.$file ~/.$file;
done

# symlink box specific brewfile
[ "$HOSTNAME" = "ABT-AG-h03647.local" ] && [ ! -h ~/Brewfile ] && ln -s $dir/work_brewfile ~/Brewfile
[ ! "$HOSTNAME" = "ABT-AG-h03647.local" ] && [ ! -h ~/Brewfile ] && ln -s $dir/home_brewfile ~/Brewfile

# symlink any additional config files to the home dir
#echo "Symlinking additional configuration files to ~"
#for sup_file in $sup_files; do
#    ln -s $dir/$sup_file ~/$sup_file
#done
