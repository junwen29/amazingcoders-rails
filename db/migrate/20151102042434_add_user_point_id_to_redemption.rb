class AddUserPointIdToRedemption < ActiveRecord::Migration
  def change
    add_column :redemptions, :user_point_id, :integer
  end
end
