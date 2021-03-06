########## added for simplecov ############
require 'simplecov'
SimpleCov.start
########## added for simplecov ############
require 'minitest/reporters'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
    Minitest::Reporters.use!
end
