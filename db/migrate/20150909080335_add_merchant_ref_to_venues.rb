class AddMerchantRefToVenues < ActiveRecord::Migration
  def change
    add_reference :venues, :merchant, index: true
  end
end
