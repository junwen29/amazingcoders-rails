require 'test_helper'

class MerchantTest < ActiveSupport::TestCase

  #========================== test positive ========================
  test "register merchant" do
    assert User.create! :name => 'John Doe', :email => 'john@gmail.com',
                        :password => 'topsecret', :password_confirmation => 'topsecret'
  end

  #========================== test negative ========================

  test "should not save merchant if email is not unique" do
    merchant_one = Merchant.new
    merchant_one.email = 'test@example.com'
    merchant_one.encrypted_password = '#$taawktljasktlw4aaglj'
    assert merchant_one.save!

    merchant_two = Merchant.new
    merchant_one.email = 'test@example.com'
    merchant_two.encrypted_password = '#$taawktljasktlw4aaglj'
    assert_no merchant_two.save!
  end

end
