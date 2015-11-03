class AddActivateDateToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :activate_date, :datetime, :default => nil
  end
end
