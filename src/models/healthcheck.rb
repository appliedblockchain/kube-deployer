class HealthcheckFailed502 < RuntimeError; end

class HealthcheckFailed301 < RuntimeError; end

class HealthcheckFailedTimeout < RuntimeError; end

class Healthcheck
  RETRY_TIMEOUT = 90 # seconds - consider a deployment failed if the container(s) are not up after (8) seconds

  URL_API = "/api/health"
  URL_REACT = "/health"
  # URL_INGRESS = "/health"
  # URL_REACT = "/health_react"

  URLS = {
    # ingress:  URL_INGRESS,
    api:   URL_API,
    react: URL_REACT,
  }

  NET = Excon
  NET.defaults[:connect_timeout] = 3
  NET.defaults[:read_timeout]    = 3
  NET.defaults[:write_timeout]   = 5

  PROTO = "https"

  attr_reader :host

  def self.check(host:)
    new(host: host).check
  end

  def initialize(host:)
    @host = host
  end

  def check
    puts "Healthcheck starting..."
    check_all
  end

  def check_all
    error = { status: :ERROR, message: "Healthcheck error", check: nil }
    URLS.each do |container, url|
      url = "#{@host}#{url}"
      puts "checking url: #{url}"
      if code = healthcheck_failing(url: url)
        error[:check] = { url: url, status_code: code, container: container }
        puts "healthcheck errored:"
        puts error.to_yaml
        return error
      end
    end
    false
  end

  def healthcheck_failing(url:)
    @time_start ||= Time.now
    status = healthcheck_failing_http url: url
    puts "healthcheck failed/status: #{status}"
    status
  rescue HealthcheckFailed502, HealthcheckFailed301, HealthcheckFailedTimeout => err
    timer = Time.now - @time_start
    return "timeout-retry" if timer > RETRY_TIMEOUT
    puts "retry - #{err.class}" if DEBUG
    sleep 1
    retry
  end

  def healthcheck_failing_http(url:)
    resp = http_get url: url
    raise HealthcheckFailed502 if resp.status == 502
    raise HealthcheckFailed301 if resp.status == 301
    return resp.status.to_s    if resp.status != 200
    false # healthcheck ok
  rescue Excon::Error::Timeout, Excon::Error::Socket => err
    raise HealthcheckFailedTimeout
  end

  private

  def http_get(url:)
    url = "#{PROTO}://#{url}"
    NET.get url
  end
end
