# personal.gitops

this is the central docker swarm setup for my personal VPS deployment setup

- [ ] traefik
- [ ] registry
- [ ] dummy app

traefik is the reverse proxy and load balancer for the docker swarm setup, all ingress traffic is routed through traefik

registry is the central docker image repository for the docker swarm setup, all docker images are stored here

gha workflows in my app repos will build and push images to the registry
