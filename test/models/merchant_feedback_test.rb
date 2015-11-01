require 'test_helper'

class MerchantFeedbackTest < ActiveSupport::TestCase
  test "save merchant feedback" do
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = "Complaint"
    content = "Cannot download PDF file"
    merchant_feedback = save_merchant_feedback(title, category, content)
    assert_difference('merchant.reload.merchant_feedbacks.count', +1) do
      assert merchant_feedback.save
    end
  end

  test "should not save merchant feedback without title" do
    merchant = merchant_one
    merchant.save

    title = nil
    category = "Complaint"
    content = "Cannot download PDF file"
    merchant_feedback = save_merchant_feedback(title, category, content)
    assert_not merchant_feedback.save
  end

  test "should not save merchant feedback without category" do
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = nil
    content = "Cannot download PDF file"
    merchant_feedback = save_merchant_feedback(title, category, content)
    assert_not merchant_feedback.save
  end

  test "should not save merchant feedback without content" do
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = "Complaint"
    content = nil
    merchant_feedback = save_merchant_feedback(title, category, content)
    assert_not merchant_feedback.save
  end

  test "view past merchant feedback" do
    # create merchant feedback
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = "Complaint"
    content = "Cannot download PDF file"
    merchant_feedback = save_merchant_feedback(title, category, content)
    merchant_feedback.save

    # view merchant feedback from merchant
    merchant_feedback = MerchantFeedback.find_by(merchant: merchant)
    assert_not_nil merchant_feedback
    assert_equal "No QR Code", merchant_feedback.title
  end

  private
  def save_merchant_feedback(title, category, content)
    MerchantFeedback.new(id: 9999, title: title, category: category, content: content, resolved: false,
                                             created_at: Date.today, updated_at: Date.today, merchant_id: '9999')
  end
end
