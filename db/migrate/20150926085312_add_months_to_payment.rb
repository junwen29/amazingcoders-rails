class AddMonthsToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :months, :integer
  end
end
