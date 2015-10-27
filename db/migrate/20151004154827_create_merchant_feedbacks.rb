class CreateMerchantFeedbacks < ActiveRecord::Migration
  def change
    create_table :merchant_feedbacks do |t|
      t.string :title
      t.string :category
      t.text :content
      t.boolean :resolved, :default  => false

      t.timestamps
    end
  end
end
