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
services:
  app:
    image: antani:staging
    environment:
    - A
    - B
  "

  def tmp_path

  end

  before :all do
    File.write "#{PATH}/tmp/yaml_source.yml",   YAML_SOURCE
    File.write "#{PATH}/tmp/yaml_override.yml", YAML_OVERRIDE
    File.write "#{PATH}/tmp/yaml_output.yml",   YAML_OUTPUT
  end

  it "merges two yamls" do
    source    = "#{PATH}/tmp/yaml_source.yml"
    override  = "#{PATH}/tmp/yaml_override.yml"
    output    = "#{PATH}/tmp/yaml_output.yml"
    merger = ConfigMerger.new
    def merger.override_dir
      "#{PATH}/tmp"
    end
    merger.merge_yml_file source_file: source, file_name: "yaml_source.yml"
  end

end
