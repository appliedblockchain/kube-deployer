module D

  class Deployer
    def self.deploy(project:, env_name:, username:)
      new.deploy project: project, env_name: env_name, username: username
    end

    def deploy(project:, env_name:, username:)
      puts "Deployment of #{project} - env: #{env_name} - triggered by: #{username} - starting"


    end
  end

end
