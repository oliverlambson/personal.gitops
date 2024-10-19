#!/usr/bin/env bash

if [ ! -f acme.json ]; then
	echo "Creating acme.json"
	echo "{}" >acme.json
fi

if [ "$(stat -c %a acme.json)" != "600" ]; then
	echo "Setting permissions for acme.json"
	chmod 600 acme.json
fi

mkdir -p cloudflare

if [ ! -f cloudflare/cert.pem ]; then
	echo "Writing origin-certificate to $(pwd)/cloudflare/cert.pem"
	echo "{{ op://oliverlambson.com/cloudflare-ssl-origin-server/origin-certificate }}" | op inject -f -o cloudflare/cert.pem
fi

if [ ! -f cloudflare/key.pem ]; then
	echo "Writing private-key to $(pwd)/cloudflare/key.pem"
	echo "{{ op://oliverlambson.com/cloudflare-ssl-origin-server/private-key }}" | op inject -f -o cloudflare/cert.pem
fi
