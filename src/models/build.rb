class Build

  include ExeLib

  def self.run(project:, containers:, env_name:)
    new.run project: project, containers: containers, env_name: env_name
  end

  def run(project:, containers:, env_name:)
    overrides_ok = apply_overrides project: project
    return false unless overrides_ok
    puts "Building containers for project #{project.f :project}"
    build_ok = build_containers containers: containers
    # TODO: raise a better exception so we need which container failed to build
    return false unless build_ok
    puts "Pushing containers for project #{project.f :project}"
    push_ok = push_containers containers: containers
    push_ok
  end

  private

  def apply_overrides(project:)
    use_overrides = project_env[:override_yml]
    config_not_present  = !override_option || override_option.to_s.empty?
    return true if config_not_present
    containers.each do |container_name|
      puts "Applying overrides to container #{container_name}"
      apply_override container_name: container_name
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
    service = yaml.f("services").values.f(0)
    service["image"] = replace_tag_name image: service["image"], env_tag: env_name
    File.write path, compose_conf.to_yaml
  end

  def replace_tag_name(image:, env_tag:)
    image.sub ":latest", ":#{env_tag}"
  end

  def dir(container_name)
    "#{PATH}/vendor/app_repo/#{container_name}"
  end

end
