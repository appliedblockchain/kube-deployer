module D

  class Deployer
    def self.deploy()
      new.deploy()
    end
    
    def deploy(project:, env_name:, username: ...)
      puts "Deployment of #{project} - env: #{env_name} - triggered by: #{username} - starting"
      
      
    end
  end

end
