class DealVenue < ActiveRecord::Base

  belongs_to :deal
  belongs_to :venue

  validates(:venue_id, presence: true)
end
