# kube-deployer

Rewrite of docker swarm deployer (to be open sourced) adapted for Kubernetes.

### Prereqs

- Ruby 2+ installed (Ruby 3 recommended)
- bundler installed (`gem i bundler`)
- `kubectx` installed (`apt install kubectx`)

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


### Running the deployer in prod

To run the deployer in production recommend using `pm2`:

    pm2 start --interpreter bash /root/kube-deployer/run.sh

`pm2` will make sure to keep the deployer app running and will provide observability on the process status.

The command above runs the deployer via pm2, use `pm2 startup && pm2 save` to make pm2 start the deployer at VM boot.
