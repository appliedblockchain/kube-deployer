ENV["RACK_ENV"] = "test"

require_relative "../src/config/env"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

# test helpers

def tmp_path
  "#{PATH}/tmp"
end

TMP_PATH = tmp_path
