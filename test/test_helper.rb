ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  self.use_instantiated_fixtures = true
  # Add more helper methods to be used by all tests here...
end

def date_is_valid?(day, month, year)
  begin
    date=(year + "-" + month + "-" + day).to_date
  rescue ArgumentError
    return false
  end
  true
end
