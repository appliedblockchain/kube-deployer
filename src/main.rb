require_relative "config/env"

include Deployer

DEPLOYER = D::Deployer

# notify_slack_start branch_name: nil, slack_user: "makevoid", project: "kubetest", environment: "ab"

# clone repo
# build each container with compose

# repo_url: "https://github.com/appliedblockchain/PROJECT_NAME"

# project: "launchpad-kube"
# containers:
#   name: "app"
#   dir:  ""
# environments:
#   xx
#   yyyy
