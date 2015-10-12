class Venue < ActiveRecord::Base
  include Venue::Json

  belongs_to :merchant
  has_many :deal_venues, inverse_of: :venue, dependent: :destroy
  has_many :deals, through:  :deal_venues
  has_many :wishes, inverse_of: :venue, dependent: :destroy
  has_many :users, through: :wishes

  attr_accessor :is_wishlist, :photo, :photo_cache

  scope :neighbourhood, ->(location) {where("neighbourhood == ?", location)}

  has_attachment :photo

  validates(:name, presence: true)
  validates(:street, presence: true)
  validates(:zipcode,presence: true)
  validates(:zipcode, :numericality => {:only_integer => true})
  validates(:neighbourhood, presence: true)
  validates(:phone, presence: true)
  validates(:phone, :numericality => {:only_integer => true})

end
