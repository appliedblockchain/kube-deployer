require_relative "main"

# monkeypatches
class Hash
  def to_sym
    self.transform_keys &:to_sym
  end
end

# TODO: extract in separate file
module ErrorResponses

  def deployment_error
    {
      code: "DeploymentFailedError",
      message: "error: deployment failed",
    }
  end

end

module DeploymentRunner

  def run_deployment(project:, env:,
    Deployer.deploy
  end

end

module SlackParams
  def get_deployment_params(r:)
    payload = JSON.parse r.params.fetch "payload"
    action = payload.fetch("actions").first

    project = get_project_from_action action   
    user = payload.fetch("user").fetch "name" 

    env = action.fetch "value"
      
    {
      project: project,
      env: env,
      user: user,
    }
  end

  def get_project_from_action(     
    # TODO pass a separate value so we don't need regexes
    project = action.fetch("name").match /environment-(?<environment>(\w+-*)+)/
    project = project[:environment]
    project.to_sym
  end
end

class DeployerApp < Roda
  plugin :json
  plugin :not_found
  plugin :error_handler
  # plugin :all_verbs
  # plugin :multi_route
  
  include DeploymentRunner
  include ErrorResponses
  include SlackParams

  route do |r|
    r.root {
      {
        status: "ok"
      }.to_sym
    }

    r.post("environments") {
      envs = Environment.all

      {
        message: "slack buttons"
      }
    }

    r.post("deployment") {
      project, env, user = get_deployment_params r: r
      puts "params - PROJECT: #{project} - ENV: #{env} - DEPLOY_BY: #{user}"

      status_info = run_deployment(
        project: project,
        environment: environment,
        user: user,
      )

      deployment_ok = true

      if deployment_ok
        {
          message: "deployment ok",
        }
      else
        status 400
        {
          message: "error",
          error: deployment_error,
        }
      end
    }
  }
  end

end

