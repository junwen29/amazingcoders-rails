class AddLocationColumnToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :location, :string
  end
end
