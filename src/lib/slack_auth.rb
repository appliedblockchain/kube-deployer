module SlackAuth

  def null(var)
    !var || var == ""
  end

  def timestamp_header(r:)
    r.headers["X-Slack-Request-Timestamp"]
  end

  def signature_header(r:)
    r.headers["X-Slack-Signature"]
  end

  def slack_auth_error_message
    { text: "Cannot deploy - Slack command is misconfigured - check the `SLACK_SIGNING_SECRET` parameter/env-var" }
  end

  def slack_wrong_secret_error_message
    {
      text: "Cannot deploy - Slack command is misconfigured - check SLACK_SIGNING_SECRET",
    }
  end

  def slack_hash_payload(payload:)
    OpenSSL::HMAC.hexdigest("SHA256", SLACK_SIGNING_SECRET, payload)
  end

  SlackAuthCheck = -> (r) {
    r.halt 200, slack_auth_error_message  if null SLACK_SIGNING_SECRET
    timestamp = timestamp_header r: r
    body = r.body.read
    payload = "v0:#{timestamp}:#{body}"
    slack_signature = signature_header r: r
    hmac256 = slack_hash_payload payload: payload
    hmac256 = "v0=#{hmac256}"
    r.halt 200, slack_wrong_secret_error_message unless slack_signature == hmac256
    true
  }

end
