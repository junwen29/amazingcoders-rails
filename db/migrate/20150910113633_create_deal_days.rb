class CreateDealDays < ActiveRecord::Migration
  def change
    create_table :deal_days do |t|
      t.boolean :mon
      t.boolean :tue
      t.boolean :wed
      t.boolean :thur
      t.boolean :fri
      t.boolean :sat
      t.boolean :sun
      t.timestamps
    end
  end
end
