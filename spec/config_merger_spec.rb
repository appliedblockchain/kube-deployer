require_relative "spec_helper"

describe "ConfigMerger" do

  YAML_SOURCE = "
services:
  app:
    image: antani:latest
    environment:
    - A
  "

  YAML_OVERRIDE = "
services:
  app:
    image: antani:staging
    environment:
    - B
  "

  YAML_OUTPUT = "
---
services:
  app:
    image: antani:staging
    environment:
    - A
    - B
  "

  before :all do
    puts `mkdir -p #{tmp_path}/overrides`
    File.write "#{tmp_path}/yaml_source.yml",   YAML_SOURCE
    File.write "#{tmp_path}/overrides/yaml_source.yml", YAML_OVERRIDE

    project = {}
    merger = ConfigMerger.new project: project, env_name: "staging"
    def merger.override_dir
      "#{tmp_path}/overrides"
    end
    def merger.stack_path
      tmp_path
    end
    @merger = merger
  end

  it "merges two yamls" do
    source    = "#{tmp_path}/yaml_source.yml"
    output = @merger.send :merge_yml_file, source_file: source, file_name: "yaml_source.yml"
    output.should == "#{YAML_OUTPUT.strip}\n"
  end

end
