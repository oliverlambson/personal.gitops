# Runbook

```sh
make secrets
bin/bootstrap-server
bin/run-remote-script swarm/0-init.sh
bin/run-remote-script swarm/1-networks.sh
```

```sh
bin/stack-deploy traefik
bin/stack-deploy dummy
bin/stack-deploy registry
bin/stack-deploy chat
```
