class Venue < ActiveRecord::Base
  has_many :deals, through:  :deal_venue
end
