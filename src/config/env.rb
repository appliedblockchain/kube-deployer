require "json"
require "yaml"
require "bundler"
Bundler.require :default#,  ...

PATH = File.expand_path "../../", __FILE__

HOST_MODE = true # use only in development
# HOST_MODE = false # TODO: switch to this in production

DEBUG = false # prints some debugging messages

# SKIP_BUILD = true # use this only in testing / development - skips the build when you just want to test repeated deployments
SKIP_BUILD = false # TODO: switch to this in production

require_relative "../lib/conf_load"
CONF_FILE_PREFIX = "kube_deployer"
include ConfLoad

require_relative "env_constants"
require_relative "conf"

require_relative "../lib/monkeypatches"
require_relative "../lib/utils"
require_relative "../lib/net_lib"
require_relative "../lib/exe_lib"
require_relative "../lib/notify_slack"
require_relative "../lib/notify_slack"
require_relative "../lib/deployer_config"
require_relative "../lib/deployer"
require_relative "../jobs/deploy_job"
require_relative "../models/environment"
require_relative "../models/clone"
require_relative "../models/build"
require_relative "../models/deploy"
require_relative "../models/healthcheck"
require_relative "../lib/slack/buttons_ui"

include NetLib
include NotifySlack

GITHUB_TOKEN = load_conf_file "github_token"
# DEPLOYER_HOST = load_conf_file "host"

ORG_NAME = "appliedblockchain"

NOTIFY_SLACK = true

# NOTE: to use an external redis host, such as aws elasticache redis (to acheive H/A), load host+secrets from config file
# AWS_REDIS_HOST = load_conf_file "aws_redis_host"
# redis_host = AWS_REDIS_HOST

redis_host = "localhost"
R = Redis.new host: redis_host

Excon.defaults[:read_timeout] = 10
