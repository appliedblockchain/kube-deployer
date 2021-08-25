class HealthcheckFailed502 < RuntimeError; end

class Healthcheck

  RETRY_TIMEOUT = 8 # seconds - consider a deployment failed if the container(s) are not up after (8) seconds

  URL_API = "/api/health"
  URL_REACT = "/health"
  # URL_INGRESS = "/health"
  # URL_REACT = "/health_react"

  URLS = {
    # ingress:  URL_INGRESS,
    api:      URL_API,
    react:    URL_REACT,
  }

  NET = Excon

  PROTO = "https"
  PROTO = "http" # TODO: switch to https

  attr_reader :host

  def self.check(host:)
    new(host: host).check
  end

  def initialize(host:)
    @host = host
  end

  def check
    check_all
  end

  def check_all
    error = { status: :ERROR, message: "Healthcheck error", check: nil }
    URLS.each do |container, url|
      url = "#{@host}#{url}"
      if code = healthcheck_failing(url: url)
        error[:check] = { url: url, status_code: code, container: container }
        puts "healthcheck errored:"
        puts error.to_yaml
        return error
      end
    end
    { status: :ok, message: "healthcheck ok", check: nil }
  end

  def healthcheck_failing(url:)
    time_start ||= Time.now
    status = healthcheck_failing_http url: url
    timer = Time.now - time_start
    return "timeout-retry" if timer > RETRY_TIMEOUT
    return status
  rescue HealthcheckFailed502 => err
    puts "healthcheck - got 502 - url: #{url}"
    sleep 0.5
    retry
  end

  def healthcheck_failing_http(url:)
    resp = http_get url: url
    raise HealthcheckFailed502 if resp.status == 502
    return resp.status.to_s if resp.status != 200
    return false # healthcheck not
  rescue Excon::Error::Timeout, Excon::Error::Socket => err
    return "timeout"
  end

  private

  def http_get(url:)
    url = "#{PROTO}://#{url}"
    NET.get url
  end

end
