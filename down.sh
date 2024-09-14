#!/usr/bin/env bash

docker stack rm registry
docker stack rm dummy
docker stack rm traefik
docker network rm private
docker network rm public
docker swarm leave --force
