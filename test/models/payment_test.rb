require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test "save payment" do
    merchant = merchant_one
    merchant.save
    payment = payment_one(Date.today, 1)
    assert_difference('merchant.reload.payments.count', +1) do
      assert payment.save
    end
  end

  test "should not save without start date" do
    merchant = merchant_one
    merchant.save
    payment = payment_one(nil, 1)
    assert_not payment.save
  end

  test "should not save without months" do
    merchant = merchant_one
    merchant.save
    payment = payment_one(Date.today, nil)
    assert_not payment.save
  end

  test "should not save if start date has passed" do
    merchant = merchant_one
    merchant.save
    payment = payment_one(Date.yesterday, 1)
    assert_not payment.save
  end

  test "should not save if plans overlap" do
    merchant = merchant_one
    merchant.save
    payment1 = payment_one(Date.today, 1)
    payment1.save
    payment2 = payment_one(Date.tomorrow, 1)
    assert_not payment2.save
  end
end
