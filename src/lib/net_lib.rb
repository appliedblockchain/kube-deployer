module NetLib

  def post(url, params)
    Excon.post url, params
  end
  
end
