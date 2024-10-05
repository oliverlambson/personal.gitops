#!/usr/bin/env bash

# advertise the private network IP (10.0.x.y)
# e.g.:
#   $ hostname -I
#   49.13.140.91 10.0.0.2 172.17.0.1 2a01:4f8:c012:ac2c::1

IP=$(hostname -I | grep -oE '10\.0\.[0-9]+\.[0-9]+' | head -n 1)
if [ -z "$IP" ]; then
	echo "Error: Unable to determine private network IP"
	exit 1
fi

docker swarm init --advertise-addr "$IP"
mkdir -p ~/stacks
