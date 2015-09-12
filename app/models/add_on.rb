class AddOn < ActiveRecord::Base
  belongs_to :plan
  belongs_to :payment
end
