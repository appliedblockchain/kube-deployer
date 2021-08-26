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

  before :all do
    YAML_SOURCE
  end

  it "merges two yamls" do
    merger = ConfigMerger.new
    YAML
    merger.merge_yml_file(source_file:, file_name:)
  end

end
