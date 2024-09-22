#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
	echo "Error: No service provided"
	exit 1
fi
service=$1

rsync -av -e ssh --exclude='.env' $service/ ollie@oliverlambson.com:~/$service/
ssh ollie@oliverlambson.com "bash -c \"./secrets.sh ~/$service/ && ./generate-config.sh -f ~/$service/compose.yaml | docker stack deploy -d -c - $service\""
