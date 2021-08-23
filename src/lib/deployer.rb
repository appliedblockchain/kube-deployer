class DeploymentStepFailed < RuntimeError;
  attr_reader :step_name

  def initialize(step_name:)
    super
    @step_name = step_name
  end
end

class Deployer

  include Utils

  def self.deploy(project:, env_name:, username:)
    new.deploy project: project, env_name: env_name, username: username
  end

  def deploy(project:, env_name:, username:)
    project_name = transform_deployer_project_name project
    notify project_name: project_name, env_name: env_name, username: username

    envs = Environment.all
    project = envs.f project_name
    project_env = project.f "#{project_name}_#{env_name}".to_sym
    branch_name = project_env.f :branch_name
    containers = project_env.f :containers

    start project_name: project_name, env_name: env_name, branch_name: branch_name, username: username

    deployment_ok = run_deployment_steps project_env: project_env, branch_name: branch_name, containers: containers, env_name: env_name
    return unless deployment_ok

    notify_slack_done project_env: project_env
  end

  private

  def run_deployment_steps(project_env:, branch_name:, containers:, env_name:)
    clone project_env: project_env, branch_name: branch_name

    build project_env: project_env, containers: containers

    deployment project_env: project_env, env_name: env_name

    healthcheck project_env: project_env
  rescue DeploymentStepFailed => err
    notify_slack_step_failed step: err.step_name
    false
  rescue Exception => err
    notify_slack_deployer_error
    puts "Error during deployment:"
    raise err
  end

  # deployment steps

  def clone(project_env:, branch_name:)
    clone_ok = Clone.run project: project_env, branch_name: branch_name
    raise DeploymentStepFailed.new step_name: "clone" unless clone_ok
    notify_slack_step step: "clone"
  end

  def build(project_env:, containers:)
    return if SKIP_BUILD
    build_ok = Build.run project: project_env, containers: containers
    raise DeploymentStepFailed.new step_name: "build" unless build_ok
    notify_slack_step step: "build"
  end

  def deployment(project_env:, env_name:)
    deploy_ok = Deploy.run project: project_env, env_name: env_name
    raise DeploymentStepFailed.new step_name: "deploy" unless deploy_ok
    notify_slack_step step: "deploy"
  end

  def healthcheck(project_env:)
    host = project_env.f :hostname
    healthcheck_fail = Healthcheck.check host: host
    raise DeploymentStepFailed.new step_name: "healthcheck" if healthcheck_fail
    notify_slack_step step: "healthcheck"
  end

  # utils

  def notify(project_name:, env_name:, username:)
    puts "Deployment of #{project_name} - env: #{env_name} - triggered by: #{username} - starting"
  end

  def start(project_name:, env_name:, branch_name:, username:)
    notify_slack_start project: project_name, environment: env_name, branch_name: branch_name, slack_user: username
  end

end
