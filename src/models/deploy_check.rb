class DeployCheck
  def check
    # TODO: add deploycheck

    exe "kubectl describe pod | grep State:"
    # all lines should be running
  end
end
