class Payment < ActiveRecord::Base
  has_one :plan
  has_many :add_ons
  belongs_to :merchant
end
