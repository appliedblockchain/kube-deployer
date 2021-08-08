require_relative "config/env"

if $0 == __FILE__
  project  = ENV["project"]  || "launchpad"
  env_name = ENV["env_name"] || "dev"
  username = ENV["username"] || "makevoid"
  project = project.to_sym
  Deployer.deploy project: project, env_name: env_name, username: username
end

# notes

# notify_slack_start branch_name: nil, slack_user: "makevoid", project: "kubetest", environment: "ab"
