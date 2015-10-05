class AddTotalPointsToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :total_points, :integer, :default => 0
  end
end
