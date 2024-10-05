#!/usr/bin/env bash

stacks=$(docker stack ls --format '{{.Name}}')
for stack in $stacks; do
	docker stack rm $stack
done

networks=$(docker network ls --filter "scope=swarm" --format '{{.Name}}' | grep -v "ingress")
for network in $networks; do
	docker network rm $network
done

docker swarm leave --force
