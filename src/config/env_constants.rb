SLACK_HOOK_SECRETS = ENV["SLACK_HOOK_SECRETS"] || load_conf_file("slack_hook_secrets") # ~/kube_deployer_slack_hook_secrets
SLACK_HOOK_URL = "https://hooks.slack.com/services/#{SLACK_HOOK_SECRETS}"
