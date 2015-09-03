class CreateDealDays < ActiveRecord::Migration
  def change
    create_table :deal_days do |t|
      t.references :deal
      t.string :day
      t.timestamps
    end
  end
end
