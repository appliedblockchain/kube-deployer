class Build

  def self.run(project:, containers:)
    new.run(project: project, containers: containers)
  end
  
  def run(project:, containers:)
    puts "Building containers for project #{project}"
    build_containers containers: containers
    puts "Pushing containers for project #{project}"
    Push.run container: container
  end
    
  def build_containers(containers:)
    containers.each do |container_name|
      puts "Building container #{container_name}"
      build_container container_name: container_name
    end
  end
  
  def build_container(container_name:)
    compose_build container_name: container_name
  end
  
  def compose_build(container_name:)
    dir = "vendor/app_repo/#{container_name}"
    ssh_exe "cd #{dir}; docker-compose build"
  end
  
end
