class Build

  def self.run(project:, containers:)
    new.run(project: project, containers: containers)
  end
  
  def run(project:, containers:)
    puts "Building containers for project #{project}"
    build_containers containers: containers
  end
    
  def build_containers(containers:)
    containers.each do |container_name|
      puts "Building container #{container_name}"
      build_container container_name: container_name
    end
  end
  
  def build_container(container_name:)
    ssh_exe "docker-compose build"
  end
  
end
