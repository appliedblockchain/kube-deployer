module NotifySlack

  def notify_slack_start(branch_name:, slack_user:, project:, environment:)
    branch = "🌵 branch: #{branch_name || "master"}"
    json = {
      text: "Deployment started (by 👨‍💻#{slack_user}) - 📦 app: #{project} - ☁ env: #{environment} - #{branch}",
    }
    notify_slack_post json
  end

  def notify_slack_step(step:)
    return unless NOTIFY_SLACK
    json = {
      text: "↪ Deployment step: '#{step}' passed",
    }
    notify_slack_post json
  end

  def notify_slack_done(status:)
    return unless NOTIFY_SLACK
    json = { text: "🚀 App deployed - #{APP_URLS_NOTE}" }
    json = { text: notify_slack_error_msg } if status == "DOWN"
    notify_slack_post json
  end

  def notify_slack_error(status:, message:)
    return unless NOTIFY_SLACK
    json = { text: "🔴 Deployer Error: #{message}" }
    notify_slack_post json
  end

  private

  def notify_slack_post(json)
    slack_url = SLACK_HOOK_URL
    resp = post slack_url, json
    puts "POST response from slack:"
    puts resp
    resp
  end

  def notify_slack_error_msg
    "Application deployed but healthcheck errored - check both application and deployer logs - cc #{DEVOPS_PERSON}"
  end

end
