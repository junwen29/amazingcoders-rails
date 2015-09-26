class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.references :venue
      t.references :user
      t.integer  :venue_id
      t.integer  :user_id
      t.timestamps
    end
  end
end
