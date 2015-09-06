class RemoveQrLinkFromDealVenues < ActiveRecord::Migration
  def self.up
    remove_column :deal_venues, :qrCodeLink
  end
end
