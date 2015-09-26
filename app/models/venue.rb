class Venue < ActiveRecord::Base
  include Venue::Json

  belongs_to :merchant
  has_many :deal_venues, inverse_of: :venue, dependent: :destroy
  has_many :deals, through:  :deal_venues
  has_many :wishes, inverse_of: :venue, dependent: :destroy
  has_many :users, through: :wishes

  attr_accessor :is_wishlist


  scope :neighbourhood, ->(location) {where("neighbourhood == ?", location)}

  has_attached_file :photo,
                    :default_url => 'biz/burpple_logo.png'

  validates(:name, presence: true)
  validates(:street, presence: true)
  validates(:address_2, presence: true)
  validates(:zipcode,presence: true)
  validates(:zipcode, :numericality => {:only_integer => true})
  validates(:neighbourhood, presence: true)
  validates(:phone, presence: true)
  validates(:phone, :numericality => {:only_integer => true})

  validates_attachment_content_type :photo, content_type: /\Aimage/
end
