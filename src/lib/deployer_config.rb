class DeployerConfig

  include Utils
  include ExeLib

  DEPLOYER_CONFIG_PATH = File.expand_path "~/deployer_config.yml"
  CONFIG_TMP_PATH      = File.expand_path "#{PATH}/deployer_config"

  # sample deployer config yml file:
  #
  # launchpad_dev: # project name
  #   project: launchpad # project name (again)
  #   env_tag: dev # staging / production
  #   github_repo: launchpad-kube # github.com/appliedblockchain/GITHUB_REPO
  #   branch_name: master
  #   hostname: launchpad.appb.ch # url to reach the ingress / load balancer
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
    exe "rm -f #{DEPLOYER_CONFIG_PATH}"
    exe "rm -rf #{CONFIG_TMP_PATH}"
    exe "git clone #{deployer_config_git_uri} #{CONFIG_TMP_PATH}"
    exe "cp #{CONFIG_TMP_PATH}/stacks.yml #{DEPLOYER_CONFIG_PATH}"
  end

  def deployer_config_git_uri
    "git@github.com:appliedblockchain/kube-deployer-config.git"
  end

end

if $0 == __FILE__
  require_relative "../config/env"
  conf = DeployerConfig.config
  pp conf
end
