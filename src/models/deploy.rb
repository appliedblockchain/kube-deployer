class Deploy

  include ExeLib

  def self.run(project:, env_name:)
    new.run project: project, env_name: env_name
  end

  def run(project:, env_name:)
    puts "Deployment starting..."

    puts "Switch kubectl context"
    context_name = project.f :context_name
    context_switch_ok = exe "kubectx #{context_name}"

    kube_ctx = exe_r "kubectx -c"
    context_matches = kube_ctx == context_name
    raise "KubeContextSwitchFailedError" if context_switch_ok && context_matches

    puts "List nodes"
    nodes_ok = exe "kubectl get nodes"

    puts "Delete old pods"
    delete_ok = exe "kubectl delete daemonsets,replicasets,deployments,pods --all"

    puts "Deploy new pods"
    deploy_ok = exe "cd #{PATH}/vendor/app_repo && kubectl apply -f stack/"

    nodes_ok && delete_ok && deploy_ok
  end

end
