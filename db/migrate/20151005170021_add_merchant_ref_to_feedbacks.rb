class AddMerchantRefToFeedbacks < ActiveRecord::Migration
  def change
    add_reference :feedbacks, :merchant, index: true
  end
end
