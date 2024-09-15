#!/usr/bin/env bash

mkcert -install
mkdir -p traefik/local/dynamic_conf/certs
pushd traefik/local/dynamic_conf/certs >/dev/null
trap popd >/dev/null
mkcert "*.com.localhost"
mkcert "*.oliverlambson.com.localhost"
mkcert "*.v2.oliverlambson.com.localhost"
