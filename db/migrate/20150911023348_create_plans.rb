class CreatePlans < ActiveRecord::Migration
  def change
    #drop_table :plans
    create_table :plans do |t|
      t.belongs_to :Payment, index: true
      t.string :name
      t.integer :cost
      t.string :description
      t.timestamps
    end
  end
end
