require 'json'
require 'yaml'
require 'bundler'
Bundler.require :default#,  ...

PATH = File.expand_path "../../", __FILE__

HOST_MODE = true # use only in development
# HOST_MODE = false # TODO: switch to this in production

SKIP_BUILD = true # use this only in testing / development - skips the build when you just want to test repeated deployments
# SKIP_BUILD = false # TODO: switch to this in production

require_relative "../lib/conf_load"
CONF_FILE_PREFIX = "kube_deployer"
include ConfLoad

require_relative "env_constants"
require_relative "conf"

require_relative "../lib/monkeypatches"
require_relative "../lib/net_lib"
require_relative "../lib/exe_lib"
require_relative "../lib/notify_slack"
require_relative "../lib/push"
require_relative "../lib/notify_slack"
require_relative "../lib/deployer_config"
require_relative "../lib/deployer"
require_relative "../models/environment"
require_relative "../models/build"
require_relative "../models/deploy"
require_relative "../models/healthcheck"
require_relative "../lib/slack/buttons_ui"

include NetLib
include NotifySlack

DEPLOYER_HOST = load_conf_file "host"

# NOTE: to use an external redis host, such as aws elasticache redis (to acheive H/A), load host+secrets from config file
# AWS_REDIS_HOST = load_conf_file "aws_redis_host"
# redis_host = AWS_REDIS_HOST

redis_host = "localhost"
R = Redis.new host: redis_host
