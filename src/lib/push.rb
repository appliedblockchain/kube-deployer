# push containers to docker registry

class Push

  def self.run
    new.run
  end
  
  def run
  
  end
  
  def push_all
    cointainers.each do |container|
      push_container container
    end
  end
  
  def push
    ssh_exe "cd dir; docker-compose push"
  end
  
end
