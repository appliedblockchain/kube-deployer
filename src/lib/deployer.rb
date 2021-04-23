class Deployer

  def self.deploy(project:, env_name:, username:)
    new.deploy project: project, env_name: env_name, username: username
  end

  def deploy(project:, env_name:, username:)
    puts "Deployment of #{project} - env: #{env_name} - triggered by: #{username} - starting"
    envs = Environment.all

    project = envs.f project
    containers = project.f :containers

    Build.run project: project, containers: containers unless SKIP_BUILD

    Deploy.run project: project, env_name: env_name

    exit

    Healtchcheck.check host: host
  end

end
