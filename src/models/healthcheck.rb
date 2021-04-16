class Healthcheck

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
