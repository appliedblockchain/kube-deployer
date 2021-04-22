class Build

  include ExeLib

  def self.run(project:, containers:)
    new.run(project: project, containers: containers)
  end

  def run(project:, containers:)
    puts "Building containers for project #{project}"
    build_containers containers: containers
    puts "Pushing containers for project #{project}"
    push_containers containers: containers
  end

  private

  def build_containers(containers:)
    containers.each do |container_name|
      puts "Building container #{container_name}"
      container_name = container_name.f :dir
      build_container container_name: container_name
    end
  end

  def push_containers(containers:)
    containers.each do |container_name|
      puts "Pushing container #{container_name}"
      container_name = container_name.f :dir
      push_container container_name: container_name
    end
  end

  def push_container(container_name:)
    compose_push container_name: container_name
  end

  def build_container(container_name:)
    compose_build container_name: container_name
  end

  def compose_build(container_name:)
    dir = "vendor/app_repo/#{container_name}"
    ssh_exe "cd #{dir} && docker-compose build"
  end

  def compose_push(container_name:)
    dir = "vendor/app_repo/#{container_name}"
    ssh_exe "cd #{dir} && docker-compose push"
  end

end
