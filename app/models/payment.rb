class Payment < ActiveRecord::Base
  has_one :plan
end
