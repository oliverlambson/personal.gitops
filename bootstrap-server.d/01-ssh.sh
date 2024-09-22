#!/usr/bin/env bash

set -euo pipefail

ssh root@$SERVER_IP <<EOF
set -euo pipefail

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

# Optional: Disable password authentication and root login for enhanced security
echo "Adjusting SSH configurations for enhanced security"

# Backup sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Disable password authentication
if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config; then
	sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
else
	echo "PasswordAuthentication no" >>/etc/ssh/sshd_config
fi

# Disable root login
if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
	sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
else
	echo "PermitRootLogin no" >>/etc/ssh/sshd_config
fi

# Restart SSH service once after all changes
systemctl restart ssh || systemctl restart sshd
EOF
