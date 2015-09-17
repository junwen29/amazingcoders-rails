class CreateAddOnPayments < ActiveRecord::Migration
  def change
    create_table :add_on_payments do |t|
      t.belongs_to :add_on, index: true
      t.belongs_to :payment, index: true
      t.timestamps
    end
  end
end
