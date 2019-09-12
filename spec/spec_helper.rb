# frozen_string_literal: true

require 'pry'
require 'bundler/setup'
require 'qiwi/kassa'
require 'webmock/rspec'
require 'helpers/webmock_helpers'

# ENV.delete_if { |k, _| k =~ /kassa/i }
# ENV["QIWI_KASSA_CONF"] = File.expand_path("fixtures/amorail_test.yml", __dir__)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec
  include QiwiKassaWebMock
end
