class Build
  include ExeLib

  def self.run(project:, containers:, env_name:)
    new.run project: project, containers: containers, env_name: env_name
  end

  def run(project:, containers:, env_name:)
    overrides_ok = apply_overrides project: project, containers: containers, env_name: env_name
    return false unless overrides_ok
    puts "Building containers for project #{project.f :project}"
    build_ok = build_containers containers: containers
    # TODO: raise a better exception so we need which container failed to build
    return false unless build_ok
    puts "Pushing containers for project #{project.f :project}"
    push_containers containers: containers
  end

  private

  def apply_overrides(project:, containers:, env_name:)
    override_option = project[:override_yml]
    config_not_present = !override_option || override_option.to_s.empty?
    return true if config_not_present
    containers.each do |container_name|
      puts "Applying overrides to container #{container_name}"
      container_name = container_name.f :dir
      apply_override container_name: container_name, env_name: env_name
    end
    true
  end

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
    exe "cd #{dir container_name} && docker-compose build"
  end

  def compose_push(container_name:)
    exe "cd #{dir container_name} && docker-compose push"
  end

  def apply_override(container_name:, env_name:)
    path = "#{dir container_name}/docker-compose.yml"
    compose_conf = YAML.load_file path
    services = compose_conf.f("services").values
    apply_override_all_containers services: services, env_name: env_name
    File.write path, compose_conf.to_yaml
  end

  def apply_override_all_containers(services:, env_name:)
    services.each do |service|
      apply_override_one_container service: service, env_name: env_name
      apply_node_env_build_arg_override service: service, env_name: env_name
    end
  end

  def apply_override_one_container(service:, env_name:)
    service["image"] = replace_tag_name image: service["image"], env_tag: env_name
    true
  end

  def apply_node_env_build_arg_override(service:, env_name:)
    build = service["build"]
    return unless build
    args = service["args"]
    return unless args
    node_env_arg = args.find { |arg| arg =~ /^NODE_ENV=/ }
    return unless node_env_arg
    args -= [node_env_arg]
    args << "NODE_ENV=#{env_name}"
    service["args"] = args
    puts "-"*80
    p service
    true
  end

  def replace_tag_name(image:, env_tag:)
    image.sub ":latest", ":#{env_tag}"
  end

  def dir(container_name)
    "#{PATH}/vendor/app_repo/#{container_name}"
  end
end
