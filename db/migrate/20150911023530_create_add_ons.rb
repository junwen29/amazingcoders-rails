class CreateAddOns < ActiveRecord::Migration
  def change
    create_table :add_ons do |t|

      t.timestamps
    end
  end
end
