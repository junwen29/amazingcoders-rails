class AddOnPayment < ActiveRecord::Base
  belongs_to :add_on
  belongs_to :payment
end
