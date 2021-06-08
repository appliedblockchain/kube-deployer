# kube-deployer

Rewrite of docker swarm deployer (to be open sourced) adapted for Kubernetes.

### Prereqs

- Ruby 2+ installed (Ruby 3 recommended)
- bundler installed (`gem i bundler`)

### Setup


    bundle


### Run

    rake


### Specs

    rake specs


### Slack configuration:

HOSTNAME = e.g. `username.eu.ngrok.io` or `deployer.abtech.run`

URLs:

Slash command - Request URL: `https://HOSTNAME/environments` (deployer v1: `/actions`)

Interactivity - Buttons - Request URL: `https://HOSTNAME/deployment` (deployer v1: `/deploy`)
