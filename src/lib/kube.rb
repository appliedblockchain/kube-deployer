module Kube
  # TODO: exec kubectl commands

  # TODO: add declarative commands

  # def pods
  #   exe kube :get, :pods
  # end
  #
  # def apply
  #   exe kube :get, :pods
  #   # exe kube :apply, "-f ...."
  # end

  def kube(command, resource, *args)
    puts "executing #{resource}.#{command}():"
    "kubectl #{command} #{resource} #{args.join " "}"
  end
end
