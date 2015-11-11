require 'test_helper'

class MerchantPointTest < ActiveSupport::TestCase
  test "credit merchant point" do
    merchant = merchant_one
    merchant.save

    reason = "Paid for a Plan upgrade"
    points = 100
    operation = "Credit"
    merchant_id = merchant.id
    date = Date.today
    merchant_point = MerchantPoint.create(id: 9999, reason: reason, points: points, operation: operation,
                                      created_at: date, updated_at: date, merchant_id: merchant_id)

    assert merchant_point.save
    assert_equal(merchant.reload.total_points, points)
  end

  test "debit merchant point" do
    merchant = merchant_one
    merchant.total_points = 200
    merchant.save

    reason = "Redeem a gift"
    points = 100
    operation = "Debit"
    merchant_id = merchant.id
    date = Date.today
    merchant_point = MerchantPoint.create(id: 9999, reason: reason, points: points, operation: operation,
                                          created_at: date, updated_at: date, merchant_id: merchant_id)

    assert merchant_point.save
    assert_equal(merchant.reload.total_points, 100)
  end

  test "view loyalty point" do
    merchant = merchant_one
    merchant.save
    save_merchant_point(merchant)

    merchant_point = MerchantPoint.find_by(merchant: merchant)
    assert_not_nil merchant_point
    assert_equal 9999, merchant_point.id
  end

  private
  def save_merchant_point(merchant)
    reason = "Paid for a Plan upgrade"
    points = 100
    operation = "Credit"
    merchant_id = merchant.id
    date = Date.today
    merchant_point = MerchantPoint.new(id: 9999, reason: reason, points: points, operation: operation,
                                       created_at: date, updated_at: date, merchant_id: merchant_id)
    merchant_point.save
  end
end
