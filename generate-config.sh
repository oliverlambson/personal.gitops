#!/usr/bin/env bash

docker compose $@ config | grep -v '^name' | sed '/published:/ s/"//g'
