#!/usr/bin/env bash

set -euo pipefail

# Disable password authentication and root login for enhanced security
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
