class Venue < ActiveRecord::Base
  has_many :deal_venues, :dependent => :destroy
  has_many :deals, through:  :deal_venues
end
