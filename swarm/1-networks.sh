#!/usr/bin/env bash

docker network create --driver overlay --subnet 10.128.0.0/24 --attachable public
docker network create --driver overlay --subnet 10.128.1.0/24 --attachable private
