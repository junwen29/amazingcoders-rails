class AddMerchantRefToDeals < ActiveRecord::Migration
  def change
    add_reference :deals, :merchant, index: true
  end
end
