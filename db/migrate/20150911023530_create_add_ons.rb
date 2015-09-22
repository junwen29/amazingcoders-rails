class CreateAddOns < ActiveRecord::Migration
  def change
    create_table :add_ons do |t|
      t.belongs_to  :payment, index: true
      t.belongs_to  :plan, index: true
      t.string      :name
      t.decimal     :cost, :precision => 8, :scale => 2
      t.string      :description
      t.string      :addon_type
      t.timestamps
    end
  end
end
