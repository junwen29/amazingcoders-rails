class CreateMerchantPoints < ActiveRecord::Migration
  def change
    #MerchantPoints refer to the receipt of MerchantPoints
    create_table :merchant_points do |t|
      t.string :reason
      t.integer :points
      t.string :operation
      t.timestamps
      t.references :merchant
    end
  end
end
