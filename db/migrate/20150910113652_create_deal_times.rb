class CreateDealTimes < ActiveRecord::Migration
  def change
    create_table :deal_times do |t|
      t.references :deal_day
      t.time :started_at, null: true, :default => nil
      t.time :ended_at, null:true, :default => nil
      t.timestamps
    end
  end
end