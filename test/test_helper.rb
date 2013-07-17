ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Devise includes some tests helpers for functional specs.  
# In other to use them, you need to include Devise in your funcitonal tests by adding the following to the bottom of your test/test_helper.rb file:
class ActionController::TestCase
  include Devise::TestHelpers
end