ENV["RAILS_ENV"] ||= "test"
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage line: 100
  minimum_coverage branch: 100
  track_files "app/**/*.rb"
end

require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def with_rails_env(name)
      singleton = Rails.singleton_class
      original_env = Rails.env

      singleton.send(:define_method, :env) { ActiveSupport::StringInquirer.new(name) }
      yield
    ensure
      singleton.send(:define_method, :env) { original_env }
    end
  end
end
