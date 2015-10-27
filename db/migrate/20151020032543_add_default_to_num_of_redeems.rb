class AddDefaultToNumOfRedeems < ActiveRecord::Migration
  def change
    remove_column :deals, :num_of_redeems, :integer
    add_column :deals, :num_of_redeems, :integer, :default => 0
  end
end
