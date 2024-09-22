#!/usr/bin/env bash

if [ ! -f traefik/acme.json ]; then
	echo "{}" >traefik/acme.json
fi
chmod 600 traefik/acme.json

generate-config() {
	docker compose $@ config | grep -v '^name' | sed '/published:/ s/"//g'
}

docker swarm init
docker network create --driver overlay --attachable public
docker network create --driver overlay --attachable private
docker network create --driver overlay --attachable loki
generate-config -f traefik/compose.yaml | docker stack deploy -d -c - traefik
# generate-config -f observability/compose.yaml | docker stack deploy -d -c - observability
generate-config -f dummy/compose.yaml | docker stack deploy -d -c - dummy
generate-config -f personal-site/compose.yaml | docker stack deploy -d -c - personal-site
# generate-config -f registry/compose.yaml | docker stack deploy -d -c - registry
