class OverrideDirNotFoundError < RuntimeError; end

class ConfigMerger

  def self.run(project:, env_name:)
    new(project: project, env_name: env_name).run
  end

  def initialize(project:, env_name:)
    @project  = project
    @env_name = env_name
  end

  def stack_path
    "#{PATH}/vendor/app_repo/stack"
  end

  def override_dir
    "#{stack_path}/overrides/#{@env_name}"
  end

  def run
    puts "override dir: #{override_dir}"
    raise OverrideDirNotFoundError unless override_dir_exists? # TODO: catch and output a slack text error message instead of a 500 (current behaviour)
    source_yml_files.each do |source_file|
      file_name = File.basename source_file
      merge_yml_file source_file: source_file, file_name: file_name
    end
    true
  end

  private

  def merge_yml_file(source_file:, file_name:)
    source_yml    = YAML.load_file source_file
    override_file_path = "#{override_dir}/#{file_name}"
    return unless override_file_exists? override_file_path
    override_yml  = load_override override_file_path: override_file_path
    merged_config = merge_config source: source_yml, override: override_yml
    write_config conf: merged_config, file_name: file_name
    merged_config
  end

  def override_file_exists?(override_file_path)
    File.exists? override_file_path
  end

  def load_override(override_file_path:)
    YAML.load_file override_file_path
  end

  def merge_config(source:, override:)
    conf = source.deep_merge override
    conf.to_yaml
  end

  def write_config(conf:, file_name:)
    File.open "#{stack_path}/#{file_name}"
  end

  def source_yml_files
    Dir.glob "#{stack_path}/*.y*ml"
  end

  def override_dir_exists?
    Dir.exist? override_dir
  end

end
