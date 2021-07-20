class DeployerConfig

  include Utils

  DEPLOYER_CONFIG_PATH = File.expand_path "~/deployer_config.yml"

  # sample deployer config yml file:
  #
  # launchpad: # project name
  #   project: launchpad # project name (again)
  #   env_tag: dev # staging / production
  #   github_repo: launchpad-kube # github.com/appliedblockchain/GITHUB_REPO
  #   branch_name: master
  #   domain: launchpad.appb.ch # url to reach the ingress / load balancer
  #   containers: # list of containers that need to be built by the build server
  #     - name: launchpad-api
  #       dir: api
  #     - name: launchpad-react
  #       dir: react
  #
  # # get the latest version from: https://github.com/appliedblockchain/kube-deployer-config/blob/main/stacks.yml

  def self.config
    new.config
  end

  def config
    deployer_config_update
    deployer_config = deployer_config_get
    deployer_config_transform deployer_config
  end

  def deployer_config_get
    puts "loading config: #{DEPLOYER_CONFIG_PATH}"
    YAML.load_file DEPLOYER_CONFIG_PATH
  end

  def deployer_config_transform(config)
    targets = {}
    config.each do |deploy_target_name, deploy_target_config|
      deploy_target_name = deploy_target_name.to_sym
      conf = deploy_target_config.transform_keys &:to_sym
      stack_name = conf.f :project
      stack_name = stack_name.to_sym
      deploy_target_project = transform_deploy_target_project deploy_target_name
      deploy_target_env = transform_deploy_target_env deploy_target_name
      conf[:deploy_target_name] = deploy_target_name
      conf[:deploy_target_env]  = deploy_target_env
      targets[deploy_target_project] = {} unless targets[deploy_target_project]
      targets[deploy_target_project][deploy_target_name] = {} unless targets[deploy_target_project][deploy_target_name]
      targets[deploy_target_project][deploy_target_name] = conf
    end
    targets
  end

  def deployer_config_update
    # TODO: clone or pull deployer config repo, overwrite deployer config file in DEPLOYER_CONFIG_PATH with deploy.yml from the repo
    # raise "TODO"
  end

end

if $0 == __FILE__
  require_relative "../config/env"
  conf = DeployerConfig.config
  pp conf
end
