# push containers to docker registry

class Push

  def self.run
    new.run
  end
  
  def run
    push_all
  end
  
  def push_all
    cointainers.each do |container|
      push_container container_name: container
    end
  end
  
  def push(container_name:)
    dir = container_name
    # TODO fixme constant
    dir = "api"
    dir = "react"
    ssh_exe "cd #{dir}; docker-compose push"
  end
  
end
