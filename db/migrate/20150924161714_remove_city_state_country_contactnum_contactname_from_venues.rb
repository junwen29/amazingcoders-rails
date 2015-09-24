class RemoveCityStateCountryContactnumContactnameFromVenues < ActiveRecord::Migration
  def self.up
    remove_column :venues, :city
    remove_column :venues, :state
    remove_column :venues, :country
    remove_column :venues, :contact_name
    remove_column :venues, :contact_number
  end
end
