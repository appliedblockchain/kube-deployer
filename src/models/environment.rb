class Environment

  GetConfig = -> { DeployerConfig.config }

  def self.all
    new.all
  end

  def all
    config = GetConfig.()
    config = symbolize config
    config
  end

  private

  # convert keys to symbols
  def symbolize(value)
    {}.tap do |h|
      value.each do |key, value|
        h[key.to_sym] = case value
        when Hash then symbolize value
        when Array then value.map{ |val| symbolize val }
        else
          value
        end
      end
    end
  end

end

if $0 == __FILE__
  require_relative "../config/env"
  require_relative "../lib/deployer_config"
  envs = Environment.all
  p envs
end
