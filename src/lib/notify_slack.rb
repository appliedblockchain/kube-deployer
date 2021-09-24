module NotifySlack
  def notify_slack_start(branch_name:, slack_user:, project:, environment:)
    branch = "🌵 branch: #{branch_name || "master"}"
    json = {
      text: "Deployment started (by 👨‍💻#{slack_user}) - 📦 app: #{project} - ☁ env: #{environment} - #{branch}",
    }
    notify_slack_post json
  end

  def notify_slack_step(step:)
    json = {
      text: "↪ Deployment step: '#{step}' passed",
    }
    notify_slack_post json
  end

  def notify_slack_step_failed(step:)
    json = {
      text: "🔴 Deployment Error: 💥 '#{step}' failed 💥 - (cc #{DEVOPS_PERSON})",
    }
    notify_slack_post json
  end

  def notify_slack_deployer_error
    json = {
      text: "🔴 Deployer Internal Error: 💥 (cc #{DEVOPS_PERSON})",
    }
    notify_slack_post json
  end

  def notify_slack_done(project_env:)
    url = "#{Healthcheck::PROTO}://#{project_env.f :hostname}"
    json = { text: "🚀 *App deployed* - #{url}#{Healthcheck::URL_API} - #{url}" }
    notify_slack_post json
  end

  private

  def notify_slack_post(json)
    return unless NOTIFY_SLACK
    slack_url = SLACK_HOOK_URL
    if DEBUG
      puts "notify slack: POST #{slack_url}"
    end
    json = json.transform_keys(&:to_s)
    json = { payload: json.to_json }
    resp = post slack_url, json
    if DEBUG
      puts "Response from slack - status: #{resp.status}"
    end
    resp
  end

  def notify_slack_error_msg
    "Application deployed but healthcheck errored - check both application and deployer logs - cc #{DEVOPS_PERSON}"
  end
end
