class Payment < ActiveRecord::Base
  has_one :plan
  has_many :add_ons
  belongs_to :merchant
  
  scope :active, -> {where("start_date <= ? AND expiry_date >= ?", Date.today, Date.today)}
  scope :expired, -> {where("expiry_date < ?", Date.today)}
end
