SLACK_HOOK_URL = ""
SLACK_HOOK_URL_PATH = ""
SLACK_HOOK_SECRETS = ENV["SLACK_HOOK_SECRETS"] || load_conf_file("slack_hook_secrets") # ~/kube_deployer_slack_hook_secrets
