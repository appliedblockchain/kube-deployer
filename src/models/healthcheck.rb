class Healthcheck

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
    resp = http_get url: url
    return resp.status.to_s if resp.status != 200
    return false
  rescue Excon::Error::Timeout => err
    return "timeout"
  end

  private

  def http_get(url:)
    url = "#{PROTO}://#{url}"
    NET.get url
  end

end
