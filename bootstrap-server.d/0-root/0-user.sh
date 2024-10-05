#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${OLLIE_PWD:-}" || -z "${PUBLIC_KEY:-}" ]]; then
	echo "Error: OLLIE_PWD and PUBLIC_KEY environment variables must be set."
	exit 1
fi

# Configure locale
echo "Configuring locale"
locale-gen en_GB.UTF-8
update-locale

# Create user 'ollie' if it doesn't exist
if id "ollie" &>/dev/null; then
	echo "User 'ollie' already exists. Skipping creation."
else
	echo "Creating user 'ollie'"
	useradd ollie --create-home --shell /bin/bash
	echo "ollie:$OLLIE_PWD" | chpasswd
	usermod -aG sudo ollie
fi

# Setup SSH for user 'ollie'
echo "Adding SSH public key for 'ollie'"
mkdir -p /home/ollie/.ssh
chmod 700 /home/ollie/.ssh
touch /home/ollie/.ssh/authorized_keys
chmod 600 /home/ollie/.ssh/authorized_keys

# Avoid duplicate keys
grep -qxF "$PUBLIC_KEY" /home/ollie/.ssh/authorized_keys || echo "$PUBLIC_KEY" >>/home/ollie/.ssh/authorized_keys
chown -R ollie:ollie /home/ollie/.ssh
