class CreateUserPoints < ActiveRecord::Migration
  def change
    create_table :user_points do |t|
      t.string      :reason
      t.integer     :points
      t.string      :operation
      t.belongs_to  :user, index: true

      t.timestamps
    end
  end
end
