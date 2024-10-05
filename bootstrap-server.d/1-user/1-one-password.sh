#!/usr/bin/env bash

set -euxo pipefail

echo "$OLLIE_PWD" | sudo -S -v

# Download & import 1Password GPG key
sudo rm -f /usr/share/keyrings/1password-archive-keyring.gpg
curl -sS https://downloads.1password.com/linux/keys/1password.asc |
	sudo gpg --no-tty --batch --status-fd --with-colons --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

# Add 1Password repository to system's software sources
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \
  https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
	sudo tee /etc/apt/sources.list.d/1password.list

# Set up debsig policy for 1Password
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
	sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

# Set up debsig keyring for 1Password
sudo rm -f /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc |
	sudo gpg --no-tty --batch --status-fd --with-colons --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# Update package lists
sudo apt-get update

# Install
sudo apt-get install 1password-cli
