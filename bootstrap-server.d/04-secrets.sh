#!/usr/bin/env bash

set -euo pipefail

# bootstrap server .env
echo "Adding .env"
cat <<EOF >.env.tmp
OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_ACCOUNT_TOKEN"
EOF
scp .env.tmp ollie@$SERVER_IP:.env
rm .env.tmp

# source .env on server
echo "Sourcing .env in .profile"
ssh ollie@$SERVER_IP <<EOF
touch "\$HOME/.profile"
if ! grep -q "^set -a; source \\\"\\\$HOME\/.env\\\"; set +a;" \$HOME/.profile; then
  echo 'set -a; source \"\$HOME/.env\"; set +a;' >> "\$HOME/.profile"
fi
EOF
