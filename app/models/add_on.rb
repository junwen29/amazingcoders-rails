class AddOn < ActiveRecord::Base
  belongs_to :plan
  #belongs_to :payment
  has_many :add_on_payments, dependent: :destroy
  has_many :payments, through: :add_on_payments
end
