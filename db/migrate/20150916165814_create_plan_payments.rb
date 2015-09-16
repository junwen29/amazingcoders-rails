class CreatePlanPayments < ActiveRecord::Migration
  def change
    create_table :plan_payments do |t|
      t.belongs_to :plan, index: true
      t.belongs_to :payment, index: true
      t.timestamps
    end
  end
end
