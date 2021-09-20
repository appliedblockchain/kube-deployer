module NetLib

  # post json
  def post(url, params)
    Excon.post(
      url,
      body: URI.encode_www_form(params),
      headers: { "Content-Type" => "application/x-www-form-urlencoded" }
    )
  end

end
