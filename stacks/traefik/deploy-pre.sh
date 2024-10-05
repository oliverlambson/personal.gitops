#!/usr/bin/env bash

if [ ! -f acme.json ]; then
	echo "Creating acme.json"
	echo "{}" >acme.json
fi

if [ "$(stat -c %a acme.json)" != "600" ]; then
	echo "Setting permissions for acme.json"
	chmod 600 acme.json
fi
