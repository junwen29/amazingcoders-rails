class AddMerchantRefToFeedbacks < ActiveRecord::Migration
  def change
    add_reference :merchant_feedbacks, :merchant, index: true
  end
end
