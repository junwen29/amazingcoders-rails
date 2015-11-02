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

  def payment_one(start_date, months)
    end_date = Date.today + 1.month
    cost  = 45 * 1
    Payment.new(id: 9999, start_date: start_date, expiry_date: end_date,
                total_cost: cost, add_on1: true, add_on2: true, add_on3: true, plan1: true,
                paid: true, merchant_id: '9999', months: months)
  end

  def venue_one(name, street, zipcode, neighbourhood, phone)
    Venue.new(id: 9999, name: name, street: street, zipcode: zipcode, city: 'Singapore',
                 state: 'Singapore', country: 'Singapore', neighbourhood: neighbourhood,
                 bio: 'ChickenUp is well known and best loved for serving Authentic Korean Fried Chicken.
By adapting the Korean methods of removing the fat from the skin and double-frying, Chicken Up Created its own distinct
variation of fried chicken, featuring juicy, sumptuous and tender chicken meat under its thin and crunchy skin without
being too greasy. Best known for its signature SpicyUp and YangNyum style fried chicken. ChickenUp also serves several
variations of the dish with the accompaniment of different sauces such as soya and curry sauces.', phone: phone,
                 address_2: '#01-44 to 47', merchant_id: '9999')
  end
end
