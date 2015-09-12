class Payment < ActiveRecord::Base
  has_one :plan
  has_many :add_ons
end
