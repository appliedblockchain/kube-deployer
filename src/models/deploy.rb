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

    delete_ok = true
    delete_old_pods = project.f :delete_pods
    if delete_old_pods
      puts "Delete old pods"
      delete_ok = exe "kubectl delete daemonsets,replicasets,deployments,pods --all"
    end

    puts "Deploy new pods"
    deploy_ok = exe "cd #{PATH}/vendor/app_repo && kubectl apply -f stack/"

    if context_name.to_s =~ /^hen/
      puts "TMP - Restart for new cluster"
      exe "kubectl rollout restart daemonset.apps/frontend"
      exe "kubectl rollout restart deployment.apps/backend"
    end

    nodes_ok && delete_ok && deploy_ok
  end
end
