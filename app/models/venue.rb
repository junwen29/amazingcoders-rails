class Venue < ActiveRecord::Base
  belongs_to :merchant
  has_many :deal_venues, inverse_of: :venue, dependent: :destroy
  has_many :deals, through:  :deal_venues

  validates(:name, presence: true)
  validates(:street, presence: true)
  validates(:address_2, presence: true)
  validates(:zipcode,presence: true)
  validates(:city, presence: true)
  validates(:state, presence: true)
  validates(:country, presence: true)
  validates(:neighbourhood, presence: true)
  validates(:phone, presence: true)
  validates(:phone, :numericality => {:only_integer => true})
end
