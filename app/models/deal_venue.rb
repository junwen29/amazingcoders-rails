class DealVenue < ActiveRecord::Base
  belongs_to :deal
  belongs_to :venue
end
