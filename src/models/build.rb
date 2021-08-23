class Build

  include ExeLib

  def self.run(project:, containers:)
    new.run project: project, containers: containers
  end

  def run(project:, containers:)
    puts "Building containers for project #{project.f :project}"
    built_ok = build_containers containers: containers
    # TODO: raise a better exception so we need which container failed to build
    return false unless build_ok
    puts "Pushing containers for project #{project.f :project}"
    push_ok = push_containers containers: containers
    push_ok
  end

  private

  def build_containers(containers:)
    containers.each do |container_name|
      puts "Building container #{container_name}"
      container_name = container_name.f :dir
      built_ok = build_container container_name: container_name
      return false unless built_ok
    end
    true
  end

  def push_containers(containers:)
    containers.each do |container_name|
      puts "Pushing container #{container_name}"
      container_name = container_name.f :dir
      push_ok = push_container container_name: container_name
      return false unless push_ok
    end
    true
  end

  def push_container(container_name:)
    compose_push container_name: container_name
  end

  def build_container(container_name:)
    compose_build container_name: container_name
  end

  def compose_build(container_name:)
    dir = "#{PATH}/vendor/app_repo/#{container_name}"
    exe "cd #{dir} && docker-compose build"
  end

  def compose_push(container_name:)
    dir = "#{PATH}/vendor/app_repo/#{container_name}"
    exe "cd #{dir} && docker-compose push"
  end

end
