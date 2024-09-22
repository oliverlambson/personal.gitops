#!/usr/bin/env bash

docker stack rm registry
docker stack rm chat
docker stack rm personal-site
docker stack rm dummy
docker stack rm observability
docker stack rm traefik
docker network rm loki
docker network rm private
docker network rm public
docker swarm leave --force
