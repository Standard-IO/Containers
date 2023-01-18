#!/bin/bash

# This script is for logging shells could work with
# interactive but is more efficient declare the env
# in the process on contruction like in containers.

# I let it, here because is reference to build other
# packages I have in mind in the future.

#updating
apt-get update
apt-get upgrade

# installing curl if it doesn't exist
type -p curl >/dev/null || apt-get install -y curl
type -p git >/dev/null || apt-get install -y git

# Creating bashrc if doesn't exist
test -f ~/.bashrc || touch ~/.bashrc

# to avoid intereactive request when intallng packages
export DEBIAN_FRONTEND=noninteractive

# Installing all the necessary tools to build python
apt-get install -y build-essential --no-install-recommends make \
    build-essential \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    xz-utils tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

#--------------------------------------pyenv-----------------------------------
# Saving the dir of this file
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# The  nextsection will crate a temp file to make a copy of .bashrc to
# try to append a little section of code to help to pyenv run when bash
# is started. If for some reason this script fail the `trap` command will
# delete it and a adition a temp file must be eliminated for security
# reasons.

trap 'rm -f "$TMPFILE"' EXIT
TMPFILE=$(mktemp) || exit 1

# Saving a backup
cat "$HOME/.bashrc" >|"$HOME/.pyenv_bashrc_backup"
# A file cannnot be part of the same opeartion for that reason is
# used a temp file
cat "$SCRIPT_DIR/pyenv_config" "$HOME/.bashrc" >|"$TMPFILE"
cat "$TMPFILE" >|"$HOME/.bashrc"

# installing pyenv and python version
curl https://pyenv.run | bash
source "$HOME/.bashrc"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:${PYENV_ROOT}/bin:$PATH"

pyenv install 3.10
pyenv global 3.10

# --------------------------- installing poetry ---------------------------------
# reviewing if the command change with the name
curl -sSL https://install.python-poetry.org | python3 - || curl -sSL https://install.python-poetry.org | python
