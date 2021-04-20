require_relative "config/env"

include Deployer

DEPLOYER = D::Deployer

if $0 == __FILE__
  project  = ENV["project"]  || "launchpad"
  env_name = ENV["env_name"] || "dev"
  username = ENV["username"] || "makevoid"
  DEPLOYER.deploy project: project, env_name: env_name, username: username
end

# notes

# notify_slack_start branch_name: nil, slack_user: "makevoid", project: "kubetest", environment: "ab"

# clone repo
# build each container with compose

# repo_url: "https://github.com/appliedblockchain/PROJECT_NAME"
