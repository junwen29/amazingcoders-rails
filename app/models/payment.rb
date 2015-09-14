class Payment < ActiveRecord::Base
  has_one :plan
  has_many :addons, through: :plan
end
