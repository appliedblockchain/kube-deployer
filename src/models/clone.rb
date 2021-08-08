class Clone

  include ExeLib

  def self.run(project:, branch_name:)
    new.run project: project, branch_name: branch_name
  end

  def run(project:, branch_name:)
    cleanup_repo
    project_details = project
    project_details.delete :containers
    puts "Cloning git repo of project:\n#{project.f :project}"
    puts project_details.to_yaml
    clone_repo project: project, branch_name: branch_name
  end

  private

  def cleanup_repo
    exe "rm -rf #{vendor_dir}/app_repo"
  end

  def clone_repo(project:, branch_name:)
    repo_name = project.f :github_repo
    clone_ok = exe "cd #{vendor_dir} && git clone git@github.com:#{ORG_NAME}/#{repo_name}.git app_repo"
    checkout_ok = exe "cd #{vendor_dir}/app_repo && git checkout #{branch_name}"
    clone_ok && checkout_ok
  end

  def vendor_dir
    "#{PATH}/vendor"
  end

end
