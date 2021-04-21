class Environment

  GetConfig = -> { DeployerConfig.config }

  def self.all
    config = GetConfig.()
    config
  end

end

if $0 == __FILE__
  require_relative "../config/env"
  require_relative "../lib/deployer_config"
  envs = Environment.all
  p envs
end
