class Healthcheck

  URL_API = "/api/health"
  URL_NGINX = "/health"
  URL_REACT = "/health_react"
  
  URLS = {
    api: URL_API,
    api: URL_API,
  }

  def self.check
    new.check
  end

  def check
    http_get url: url
  end

  private

  def http_get(url:)
    Excon.get url
  end

end
