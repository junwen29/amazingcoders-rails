require 'test_helper'

class MerchantTest < ActiveSupport::TestCase

  #========================== test positive ========================
  test "register merchant" do
    assert Merchant.create! :email => 'john@gmail.com',
                        :password => 'topsecret', :password_confirmation => 'topsecret'
  end

  #========================== test negative ========================

  test "should not save merchant if email is not unique" do
    merchant_one = Merchant.new
    merchant_one.email = 'test@example.com'
    merchant_one.password = 'topsecret'
    merchant_one.password_confirmation = 'topsecret'
    assert merchant_one.save!

    merchant_two = Merchant.new
    merchant_two.email = 'test@example.com'
    merchant_two.password = 'topsecret'
    merchant_two.password_confirmation = 'topsecret'
    assert_not merchant_two.save!
  end

end
