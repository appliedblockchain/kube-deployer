class DeployJob
  include SuckerPunch::Job
  workers 1
  max_jobs 1

  def perform(project:, env_name:, username:)
    Deployer.deploy project: project, env_name: env_name, username: username
  end
end

# DeployJob.perform_async
