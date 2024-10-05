#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname "${BASH_SOURCE[0]}")

echo "Adding $script_dir/../../server/home/ to ~"

rsync \
	-av \
	-e ssh \
	"$script_dir/../../server/home/" \
	ollie@oliverlambson.com:~/
