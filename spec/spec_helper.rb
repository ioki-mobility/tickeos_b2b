# frozen_string_literal: true

require 'bundler/setup'
require 'tickeos_b2b'
require 'webmock/rspec'
require 'active_support/core_ext/time'
require 'awesome_print'
require 'pry'

WebMock.enable!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  Time.zone = 'Monrovia' # Monrovia has the same offset as UTC, but is not considered to be an UTC time by ActiveSupport

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Guard tries to run only tests with the focus tag, if this would filter out
  # all specs, run all tests.
  config.run_all_when_everything_filtered = true
end
