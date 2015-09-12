class CreateAddOns < ActiveRecord::Migration
  def change
    create_table :add_ons do |t|
      t.string :name
      t.integer :cost
      t.string :description
      t.timestamps
    end
  end
end
