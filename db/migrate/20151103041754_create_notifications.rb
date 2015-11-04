class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.string  :item_type
      t.integer :item_id
      t.string  :item_name
      t.text    :message
      t.timestamps
    end
  end
end
