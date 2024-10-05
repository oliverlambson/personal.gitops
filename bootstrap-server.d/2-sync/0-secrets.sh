#!/usr/bin/env bash

set -euo pipefail

if [ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]; then
	echo "Error: OP_SERVICE_ACCOUNT_TOKEN is not set"
	exit 1
fi

echo "Adding .env to ~"

cat <<EOF >.env.tmp
OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_ACCOUNT_TOKEN"
EOF

rsync \
	-av \
	-e ssh \
	.env.tmp \
	ollie@oliverlambson.com:~/.env

rm .env.tmp
