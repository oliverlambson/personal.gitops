#!/usr/bin/env bash

docker swarm init
docker network create --driver overlay --attachable public
docker network create --driver overlay --attachable private
docker stack deploy -d -c traefik/compose.yaml traefik
docker stack deploy -d -c dummy/compose.yaml dummy
docker stack deploy -d -c registry/compose.yaml registry
