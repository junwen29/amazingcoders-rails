class CreateDealTimes < ActiveRecord::Migration
  def change
    create_table :deal_times do |t|
      t.time :started_at
      t.time :ended_at
      t.timestamps
    end
  end
end
