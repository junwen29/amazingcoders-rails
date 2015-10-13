class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
      t.belongs_to :deal, index: true
      t.belongs_to :user, index: true
      t.integer :venue_id
      t.timestamps
    end
  end
end
