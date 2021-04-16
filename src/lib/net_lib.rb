module NetLib

  # post json
  def post(url, params)
    params = JSON.dump params
    Excon.post url, body: params
  end

end
