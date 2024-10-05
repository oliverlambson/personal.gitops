# personal.gitops

> next up: cicd deployment of personal-site

Central configuration of my personal VPS deployment setup using docker swarm.
Other deployments are managed in the app repos.

## Stacks TODO

- [ ] traefik
  - [x] localhost TLS
  - [ ] base hostname with go template? (e.g. dev.oliverlambson.com vs oliverlambson.com) (could do with compose env vars)
  - [x] private/public services (kinda, with ipAllowList middleware)
  - [ ] private/public services with vpn
- [x] registry
  - [x] basic
  - [x] auth
- [x] dummy app
- [ ] observability
  - [x] logs (alloy > loki > grafana)
  - [ ] metrics (alloy > prometheus > grafana) - ([prometheus docker swarm export example](https://grafana.com/docs/alloy/latest/reference/components/discovery/discovery.dockerswarm/#example))
  - [ ] healthchecks (alloy > prometheus > grafana)
  - [ ] alerting (alloy > prometheus > alert manager) - ([gmail smtp relay](https://apps.google.com/supportwidget/articlehome?hl=en&article_url=https%3A%2F%2Fsupport.google.com%2Fa%2Fanswer%2F176600%3Fhl%3Den&assistant_id=generic-unu&product_context=176600&product_name=UnuFlow&trigger_context=a))
- [ ] vpn
  - [ ] wireguard vpn
  - [ ] dns

## Deployment TODO

- [ ] replace coolify for oliverlambson.com
  - [x] these services up
    - [x] traefik
    - [x] dummy
    - [x] personal-site
    - [x] chat (open-webui)
    - [x] registry
  - [ ] cicd deployment of personal-site (build > push to registry > update stack definition > deploy stack)
    - [x] makefile deployment with docker save & scp
    - [x] makefile deployment with private registry
    - [ ] cicd
  - [ ] cicd deployment of personal.gitops?
- [ ] infra with terraform/pulumi
  - [ ] cloudflare dns
  - [ ] cloudflare r2 object storage (s3 api so [nothing clever](https://grafana.com/docs/loki/latest/configure/storage/#on-premise-deployment-minio-single-store), they just have 10GB free tier)
    - [ ] registry storage ([s3StorageDriver](https://distribution.github.io/distribution/storage-drivers/s3/))
    - [ ] loki backend ([s3 single store tsdb](https://grafana.com/docs/loki/latest/configure/storage/#aws-deployment-s3-single-store))
    - [ ] (eventually) db backups
- [ ] multi-server
  - [ ] second VPS join the docker swarm

## how to deploy stacks

Each folder is a docker swarm stack.

Deploy a stack with:

```sh
./deploy.sh [STACK]
```

## the plan

`traefik` is the reverse proxy and load balancer for the docker swarm setup, all ingress traffic is routed through traefik

`registry` is the central docker image repository for the docker swarm setup, all docker images are stored here

gha workflows in my app repos will build and push images to the registry

generate .env files using `./secrets.sh` (uses one password cli with the .env.op templates)

(local testing) generate localhost certs with mkcert

```
personal-gitops
├── bin                        <<- local scripts to manage deployment to server
│   ├── bootstrap-server         - configure new server from scratch (runs all of bootstrap-server.d/)
│   ├── run-remote-cmd           - run single bash cmd on server over ssh
│   ├── run-remote-script        - run bash script on server over ssh
│   ├── stack-deploy             - deploy a specific stack (in stacks/) to server
│   └── sync-stack               - sync spec in stacks/$stack to server
├── bootstrap-server.d         <<- local scripts to configure new server
│   ├── 0-root                   - set up user & harden ssh (run as root)
│   │   ├── 0-user.sh
│   │   └── 1-ssh.sh
│   ├── 1-user                   - install needed programmes (run as user)
│   │   ├── 0-docker.sh
│   │   └── 1-one-password.sh
│   └── 2-sync                   - bootstrap secrets & sync files to server
│       ├── 0-secrets.sh         -- 1password service account
│       ├── 1-rc.sh              -- sync server/home to ~
│       └── 2-bin.sh             -- sync servier/bin to ~/bin
├── server                     <<- gets synced to the server
│   ├── bin                      - server-side scripts for ~/bin
│   │   ├── deploy-stack
│   │   ├── op-dotenv
│   │   └── render-compose
│   └── home                     - server-side bash config
│       ├── .bashrc                (make .env & ~/bin available by default w/ ssh)
│       └── .profile
├── stacks                     <<- swarm stacks
│   ├── registry                 - private docker registry
│   │   ├── .rsyncignore
│   │   └── compose.yaml
│   ├── traefik                  - load balancer & reverse proxy
│   │   ├── .rsyncignore
│   │   ├── compose.yaml
│   │   ├── deploy-pre.sh
│   │   └── ...
│   └── {service}                - any other service
│       ├── .rsyncignore
│       └── compose.yaml
├── swarm                      <- swarm initialisation scripts
│   ├── 0-init.sh
│   └── 1-networks.sh
├── Makefile
├── README.md
└── RUNBOOK.md
```
