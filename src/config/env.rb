require 'bundler'
Bundler.require :default#,  ...

PATH = File.expand_path "../../", __FILE__

require_relative "../lib/conf_load"
CONF_FILE_PREFIX = "kube_deployer"
include ConfLoad

require_relative "env_constants"
require_relative "conf"

require_relative "../lib/net_lib"
require_relative "../lib/notify_slack"

include NetLib
include NotifySlack
