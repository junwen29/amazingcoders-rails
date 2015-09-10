class Venue < ActiveRecord::Base
  belongs_to :merchant
  has_many :deal_venues, inverse_of: :venue, dependent: :destroy
  has_many :deals, through:  :deal_venues
end
