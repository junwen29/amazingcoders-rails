class RemoveLocationNumredeemsFromDeals < ActiveRecord::Migration
  def self.up
    remove_column :deals, :location
    remove_column :deals, :num_of_redeems
  end
end
