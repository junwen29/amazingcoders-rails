class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer  :user_id
      t.references :user
      t.string :device_type
      t.string :token
      t.timestamps
    end
  end
end
