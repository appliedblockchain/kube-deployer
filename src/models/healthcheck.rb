class Healthcheck

  URL_INGRESS = "/health"
  URL_API = "/api/health"
  URL_REACT = "/health_react"

  URLS = {
    ingress:  URL_INGRESS,
    api:      URL_API,
    react:    URL_REACT,
  }

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
    URLS.each do |url|
      check_url url: url
    end
  end

  def check_url(url:)
    url = "#{@host}/#{url}"
    resp = http_get url: url
    raise resp.status.inspect
  end

  private

  def http_get(url:)
    Excon.get url
  end

end
