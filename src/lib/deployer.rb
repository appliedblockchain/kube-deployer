class Deployer

  include Utils

  def self.deploy(project:, env_name:, username:)
    new.deploy project: project, env_name: env_name, username: username
  end

  def deploy(project:, env_name:, username:)
    project_name = transform_deployer_project_name project
    puts "Deployment of #{project_name} - env: #{env_name} - triggered by: #{username} - starting"
    envs = Environment.all

    project = envs.f project_name
    project_env = project.f "#{project_name}_#{env_name}".to_sym
    containers = project_env.f :containers

    Clone.run project: project_env

    Build.run project: project_env, containers: containers unless SKIP_BUILD

    Deploy.run project: project_env, env_name: env_name

    exit

    Healtchcheck.check host: host
  end

end
