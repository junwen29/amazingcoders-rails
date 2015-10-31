class CreateDealAnalytics < ActiveRecord::Migration
  def change
    create_table :deal_analytics do |t|
      t.belongs_to :deal, index: true
      t.integer :view_count, default: 0
      t.integer :unique_view_count, default: 0
      t.integer :redemption_count, default: 0
      t.timestamps
    end
  end
end
