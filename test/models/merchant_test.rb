require 'test_helper'

class MerchantTest < ActiveSupport::TestCase
  test "register merchant" do
    merchant = merchant_one
    assert merchant.save
  end

  test "should not save merchant if email is not unique" do
    merchant1 = merchant_one
    merchant1.save
    merchant2 = merchant_two
    assert_not merchant2.save
  end

end
