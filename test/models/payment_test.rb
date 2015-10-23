require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #========================== test negative ========================

  test "should not save without start date" do
    payment = Payment.new
    assert_not payment.save
  end

  test "should not save without months" do
    payment = Payment.new
    assert_not payment.save
  end

  test "should not save if start date not passed" do
    payment = Payment.new
    payment.start_date= "2099-10-22"
    assert_not payment.save
  end

  test "should not save if plans overlap" do
    assert_not payment.save
  end


end
