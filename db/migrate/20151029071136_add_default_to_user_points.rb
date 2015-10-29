class AddDefaultToUserPoints < ActiveRecord::Migration
  def change
    remove_column :users, :total_points, :integer
    add_column :users, :total_points, :integer, :default => 0
  end
end
