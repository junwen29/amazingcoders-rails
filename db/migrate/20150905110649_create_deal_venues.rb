class CreateDealVenues < ActiveRecord::Migration
  def change
    create_table :deal_venues do |t|
      t.belongs_to :deal, index: true
      t.belongs_to :venue, index: true
      t.string :qrCodeLink
      t.timestamps
    end
  end
end
