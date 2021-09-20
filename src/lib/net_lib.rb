module NetLib

  # post json
  def post(url, params)
    params = params.transform_keys &:to_s
    params = JSON.dump params
    Excon.post url, body: params
  end

end
