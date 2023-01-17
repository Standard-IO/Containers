#!/bin/bash

#updating
apt update
apt upgrade

# installing curl if it doesn't exist
type -p curl > /dev/null || apt install -y curl
type -p git > /dev/null || apt install -y git

# Creating bashrc if doesn't exist
test -f ~/.bashrc || touch ~/.bashrc

# Installing c compiler
type -p gcc > /dev/null || apt install -y build-essential

#--------------------------------------pyenv-----------------------------------
# Saving the dir of this file
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# The  nextsection will crate a temp file to make a copy of bashrc to try to append
# a little section of code to help to pyenv run when bash is started.
# If for some reason this script fail the trap command will delete it. And 
# aditionally a temp file must be eliminated for security reasons.
trap 'rm -f "$TMPFILE"' EXIT 
TMPFILE=$(mktemp) || exit 1 

# Saving a backup
cat "$HOME/.bashrc" >| "$HOME/.pyenv_bashrc_backup"
# A file cannnot be part of the same opeartion for that reason is
# used a temp file
cat "$SCRIPT_DIR/pyenv_config" "$HOME/.bashrc" >| "$TMPFILE"
cat  "$TMPFILE"  >| "$HOME/.bashrc"

# installing pyenv and python version
curl https://pyenv.run | bash
source "$HOME/.bashrc"
pyenv install 3.10
pyenv global 3.10

#add an alias to python3 to ,bashrc
echo 'alias python="python3"' >> "$HOME/.bashrc"

# --------------------------- installing poetry ---------------------------------
# curl -sSL https://install.python-poetry.org | python3 -
