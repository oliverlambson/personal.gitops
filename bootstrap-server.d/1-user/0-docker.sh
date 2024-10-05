#!/usr/bin/env bash

set -euxo pipefail

echo "$OLLIE_PWD" | sudo -S -v

# Add Docker's official GPG key:
echo "add docker gpg key"
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "add docker repository to apt sources"
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update

# install docker
echo "install docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# allow non-sudo docker
echo "allow non-sudopass docker"
if ! getent group docker >/dev/null 2>&1; then
	sudo groupadd docker
	echo "Docker group created"
else
	echo "Docker group already exists"
fi

if ! groups $USER | grep -q '\bdocker\b'; then
	sudo usermod -aG docker $USER
	echo "User $USER added to Docker group"
else
	echo "User $USER is already in Docker group"
fi

# Refresh group membership without logging out
if ! groups $USER | grep -q '\bdocker\b'; then
	newgrp docker
fi

echo "done"
