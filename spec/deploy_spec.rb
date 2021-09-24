require_relative "spec_helper"

include ExeLib

describe "Deploy - Main spec" do
  it "loads the environment correctly" do
    Deployer.should be_a Module
  end

  it "updates the deployer config" do
    exe "rm -f ~/deployer.yml"
    DeployerConfig.config
    File.exist?(File.expand_path("~/deployer_config.yml")).should be true
  end

  it "clones the app repo" do
    project = {
      project:     "launchpad",
      github_repo: "launchpad-kube",
    }
    Clone.run project: project, branch_name: "master"
    File.exist?(File.expand_path("#{PATH}/vendor/app_repo/stack/api-deployment.yaml")).should be true
  end

  xit "deploys the containers" do
  end
end
