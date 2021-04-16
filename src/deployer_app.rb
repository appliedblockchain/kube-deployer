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

  def run_deployment

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

  route do |r|
    r.root {
      {
        status: "ok"
      }.to_sym
    }

    r.post("environments") {
      envs = Environment.all

      #

      {
        message: "slack buttons"
      }
    }

    r.post("deployment") {
      deployment_ok = true

      run_deployment

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

