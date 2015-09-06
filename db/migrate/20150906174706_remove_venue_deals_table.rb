class RemoveVenueDealsTable < ActiveRecord::Migration
  def self.up
    drop_table :venue_deals
  end
end
