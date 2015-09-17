class PlanPayment < ActiveRecord::Base
  belongs_to :plan
  belongs_to :payment
end
