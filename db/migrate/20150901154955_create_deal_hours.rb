class CreateDealHours < ActiveRecord::Migration
  def change
    create_table :deal_hours do |t|
      t.references :deal
      t.string :day
      t.time :started_at
      t.time :ended_at

      t.timestamps
    end
  end
end
