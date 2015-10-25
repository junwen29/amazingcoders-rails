class CreateUserPoints < ActiveRecord::Migration
  def change
    create_table :user_points do |t|
      t.string :reason
      t.integer :points
      t.string :operation
      t.integer :user_id

      t.timestamps
    end
  end
end
