class AddTotalPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_points, :integer
  end
end
