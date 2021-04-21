module  Deploy

  include ExeLib

  # TODO: run kubectl

  def self.run(project:, env_name:)
    new.run project: project, env_name: env_name
  end

  def run(project:, env_name:)
    puts "Deployment starting..."

    ssh_exe "cd vendor/app_repo && kubectl apply -f stack/"
  end

end
