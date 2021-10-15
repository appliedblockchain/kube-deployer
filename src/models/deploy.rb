class Deploy
  include ExeLib

  def self.run(project:, env_name:)
    new.run project: project, env_name: env_name
  end

  def run(project:, env_name:)
    puts "Deployment starting..."

    puts "Switch kubectl context"
    context_name = project.f :kube_context
    context_switch_ok = exe "kubectx #{context_name}"

    # not available on debian 10 kubectx package yet - TODO: add
    # kube_ctx = r_exe "kubectx -c"
    # context_matches = kube_ctx == context_name
    context_matches = true

    raise "KubeContextSwitchFailedError" if !context_switch_ok && context_matches

    puts "List nodes"
    nodes_ok = exe "kubectl get nodes"

    # TODO: consider if we really need this
    # puts "Delete old pods"
    # delete_ok = exe "kubectl delete daemonsets,replicasets,deployments,pods --all"

    puts "Deploy new pods"
    deploy_ok = exe "cd #{PATH}/vendor/app_repo && kubectl apply -f stack/"

    nodes_ok && delete_ok && deploy_ok
  end
end
