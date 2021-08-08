class DeployCheck

  def check

    exe "kubectl describe pod | grep State:"
    # all lines should be running

  end
  
end
