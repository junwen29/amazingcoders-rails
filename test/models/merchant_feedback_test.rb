require 'test_helper'

class MerchantFeedbackTest < ActiveSupport::TestCase
  test "save merchant feedback" do
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = "Complaint"
    content = "Cannot download PDF file"
    merchant_feedback = merchant_feedback_one(title, category, content)
    assert merchant_feedback.save
  end

  test "should not save merchant feedback without title" do
    merchant = merchant_one
    merchant.save

    title = nil
    category = "Complaint"
    content = "Cannot download PDF file"
    merchant_feedback = merchant_feedback_one(title, category, content)
    assert_not merchant_feedback.save
  end

  test "should not save merchant feedback without category" do
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = nil
    content = "Cannot download PDF file"
    merchant_feedback = merchant_feedback_one(title, category, content)
    assert_not merchant_feedback.save
  end

  test "should not save merchant feedback without content" do
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = "Complaint"
    content = nil
    merchant_feedback = merchant_feedback_one(title, category, content)
    assert_not merchant_feedback.save
  end

  test "view past merchant feedback" do
    # create merchant feedback
    merchant = merchant_one
    merchant.save

    title = "No QR Code"
    category = "Complaint"
    content = "Cannot download PDF file"
    merchant_feedback = merchant_feedback_one(title, category, content)
    merchant_feedback.save

    # view merchant feedback from merchant
    merchant_feedback = MerchantFeedback.find_by(merchant: merchant)
    assert_not_nil merchant_feedback
    assert_equal "No QR Code", merchant_feedback.title
  end
end
