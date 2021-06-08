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

  def run_deployment(project:, env:)
    Deployer.deploy
  end

end

module SlackParams
  def get_deployment_params(r:)
    p r.params.inspect
    payload = JSON.parse r.params.f "payload"
    action = payload.f("actions").first

    project = get_project_from_action action: action
    user = payload.f("user").f "name"

    env = action.f "value"

    {
      project: project,
      env: env,
      user: user,
    }
  end

  def get_project_from_action(action:)
    # TODO pass a separate value so we don't need regexes
    project = action.f("name").match(/environment-(?<environment>(\w+-*)+)/)
    # project = action.f("name").match(/^environment-(*.+)$/)
    project = project[:environment]
    project.to_sym
  end
end

# TODO move in deployer
module DeploymentTriggering

  def deployment_trigger_new!(project:, environment:, user:)
    puts "starting a new deployment"
    R.setex "environments:current", DEPLOYMENT_MAX_TIME, Time.now.to_i

    Thread.new do
      output = deploy! project: project, environment: environment, user: user
      puts "DEPLOYMENT COMPLETE!"
      puts output
    end

    {
      status: "deploying",
      project: project,
      environment: environment
    }
  end

  def deployment_wait_end(wait_time:)
    puts "tried to retrigger - stopped: waiting for the deployment to finish..."
    minutes = (wait_time / 60).floor
    time_left = "#{minutes} min #{(wait_time - minutes*60).ceil} sec"
    { status: "waiting", wait_time_left: time_left }
  end

  def start_deployment!(project:, environment:, user:)
    time_cache = R["environments:current"]
    time = Time.at time_cache.to_i if time_cache
    if time && time + DEPLOYMENT_MAX_TIME >= Time.now
      time_left = time + DEPLOYMENT_MAX_TIME - Time.now
      deployment_wait_end wait_time: time_left
    else
      deployment_trigger_new! project: project, environment: environment, user: user
    end
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
      panels = Slack::ButtonsUI.display deployer_config: envs


      messages = [
        {
          text: "*Trigger deployment:*",
          status: "OK",
        }, {
          text: "",
          attachments: panels,
        }
      ]

      {
        text: "",
        attachments: messages,
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

  end

end
