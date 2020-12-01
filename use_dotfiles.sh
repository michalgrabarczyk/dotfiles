#!/bin/bash 

read -p "This script will replace all of your dotfiles. Continue? [y/n] " -n 1 -r
echo # move to the new line

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating symlinks..."

    ln -sf "$SCRIPT_DIR"/.bashrc ~/.bashrc ; echo ".bashrc symlink created"
    ln -sf "$SCRIPT_DIR"/.gitconfig ~/.gitconfig ; echo ".gitconfig symlink created"
    ln -sf "$SCRIPT_DIR"/.gitignore ~/.gitignore ; echo ".gitignore symlink created"
    ln -sf "$SCRIPT_DIR"/.clang-format ~/.clang-format ; echo ".clang-format symlink created"
    ln -sf "$SCRIPT_DIR"/.emacs.d/ ~/.emacs.d ; echo ".emacs.d/ symlink created"
    
    echo "Creating symlinks done!"
fi

