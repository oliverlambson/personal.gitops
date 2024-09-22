# personal.gitops

> next up: deploy this version to replace coolify on oliverlambson.com

this is the central docker swarm setup for my personal VPS deployment setup

- services
  - [ ] traefik
    - [x] localhost TLS
    - [ ] base hostname with go template? (e.g. dev.oliverlambson.com vs oliverlambson.com)
    - [x] private/public services (with ipAllowList middleware)
  - [ ] registry
    - [x] basic
    - [ ] auth
  - [x] dummy app
  - [ ] observability
    - [x] logs (alloy > loki > grafana)
    - [ ] metrics (alloy > prometheus > grafana) - ([prometheus docker swarm export example](https://grafana.com/docs/alloy/latest/reference/components/discovery/discovery.dockerswarm/#example))
    - [ ] healthchecks (alloy > prometheus > grafana)
    - [ ] alerting (alloy > prometheus > alert manager) - ([gmail smtp relay](https://apps.google.com/supportwidget/articlehome?hl=en&article_url=https%3A%2F%2Fsupport.google.com%2Fa%2Fanswer%2F176600%3Fhl%3Den&assistant_id=generic-unu&product_context=176600&product_name=UnuFlow&trigger_context=a))
- deployment
  - [ ] replace coolify for oliverlambson.com
    - [ ] these services up
    - [ ] personal-site up
    - [ ] cicd deployment of personal-site (build > push to registry > update stack definition > deploy stack)
    - [ ] cicd deployment of open-webui
    - [ ] cicd deployment of personal.gitops?
  - [ ] infra with terraform/pulumi
    - [ ] cloudflare dns
    - [ ] cloudflare r2 object storage (s3 api so [nothing clever](https://grafana.com/docs/loki/latest/configure/storage/#on-premise-deployment-minio-single-store), they just have 10GB free tier)
      - [ ] registry storage ([s3StorageDriver](https://distribution.github.io/distribution/storage-drivers/s3/))
      - [ ] loki backend ([s3 single store tsdb](https://grafana.com/docs/loki/latest/configure/storage/#aws-deployment-s3-single-store))
      - [ ] (eventually) db backups
  - [ ] multi-server
    - [ ] second VPS join the docker swarm

traefik is the reverse proxy and load balancer for the docker swarm setup, all ingress traffic is routed through traefik

registry is the central docker image repository for the docker swarm setup, all docker images are stored here

gha workflows in my app repos will build and push images to the registry

generate localhost certs with mkcert

generate .env files using `./secrets.sh` (uses one password cli with the .env.op templates)
