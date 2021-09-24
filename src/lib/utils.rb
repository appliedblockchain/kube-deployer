module Utils
  def transform_deployer_project_name(deploy_target_name)
    deploy_target_name.to_s.split("-")[0].to_sym
  end

  def transform_deploy_target_project(deploy_target_name)
    deploy_target_name.to_s.split("_")[0].to_sym
  end

  def transform_deploy_target_env(deploy_target_name)
    deploy_target_name.to_s.split("_")[1..-1].join("_").to_sym
  end
end
