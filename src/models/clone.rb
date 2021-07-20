class Clone

  include ExeLib

  def self.run(project:)
    new.run project: project
  end

  def run(project:)
    puts "Cloning git repo of project #{project.f :project}"
    clone_repo project: project
  end

  private

  def clone_repo(project:)
    dir = "#{PATH}/vendor"
    repo_name = project.f :github_repo
    # ssh_exe "cd #{dir} && rm -rf app_repo"
    ssh_exe "cd #{dir} && git clone git@github.com:#{ORG_NAME}/#{repo_name}.git app_repo"
  end

end
