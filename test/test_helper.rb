ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  # fixtures :merchants

  # Add more helper methods to be used by all tests here...
  def merchant_one
    merchant = Merchant.new(id: '9999')
    merchant.email = 'john@gmail.com'
    merchant.password = 'topsecret'
    merchant.password_confirmation = 'topsecret'
    merchant
  end

  def merchant_two
    merchant = Merchant.new(id: '9998')
    merchant.email = 'john@gmail.com'
    merchant.password = 'topsecret'
    merchant.password_confirmation = 'topsecret'
    merchant
  end
end
