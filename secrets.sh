#!/usr/bin/env bash

set -a
source $HOME/.env
set +a

find ${1:-.} -name "*.op" | xargs -n 1 -I FILE sh -c 'echo "Processing $1"; op inject -i "$1" -o "${1%.op}"' _ FILE
