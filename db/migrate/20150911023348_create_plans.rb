class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.String :name
      t.integer :cost
      t.String :description
      t.timestamps
    end
  end
end
