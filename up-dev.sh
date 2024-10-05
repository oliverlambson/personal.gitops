#!/usr/bin/env bash

if [ ! -f traefik/acme.json ]; then
	echo "{}" >traefik/acme.json
fi
chmod 600 traefik/acme.json

docker swarm init

docker network create --driver overlay --attachable public
docker network create --driver overlay --attachable private

docker stack deploy -d -c traefik/compose.yaml -c traefik/compose.dev.yaml traefik
docker stack deploy -d -c observability/compose.yaml observability
docker stack deploy -d -c dummy/compose.yaml dummy
docker stack deploy -d -c registry/compose.yaml registry
