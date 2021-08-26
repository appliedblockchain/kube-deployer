require_relative "spec_helper"

module SpecSetup
  Resp = Object.new
  def Resp.status
    200
  end
  excon = Excon
  def excon.get(url)
    Resp
  end
  Healthcheck::NET = excon
end

include SpecSetup

describe "Healthcheck spec" do

  let(:hc) { Healthcheck.new host: "test" }

  it "instantiates" do
    hc.should be_an Healthcheck
  end

  it "healthchecks the deployment" do
    check = hc.check
    check.should be false

    # TODO: re-implement with mocks
    # check.should be_an Hash
    # check.should have_key :status
    # check[:status].should == :ok
    # check.should have_key :check
    #
    # def Resp.status
    #   402
    # end
    #
    # check = hc.check
    # check[:check].should be_an Hash
    # check = check[:check]
    # check.should have_key :url
    # check.should have_key :status_code
    # check.should have_key :container
    # check[:container].should == :ingress
    # check[:url].should == "test/health"
    # check[:status_code].should == 402
    #
    # # TODO: implement - if you receive 402 then probably your load balancer is not configured correctly
    # # - if you receive 500 probably your application is erroring
  end

end
