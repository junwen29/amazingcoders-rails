class CreatePayments < ActiveRecord::Migration
  def change
   #  drop_table :payments
    create_table :payments do |t|
      t.date        :start_date
      t.date        :expiry_date
      t.decimal     :total_cost, :precision => 8, :scale => 2
   #   p.boolean :paid
      t.boolean     :add_on1
      t.boolean     :add_on2
      t.boolean     :add_on3
      t.boolean     :plan1
      t.timestamps
    end
  end
end