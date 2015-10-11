class AddOn < ActiveRecord::Base
  belongs_to :plan
  #belongs_to :payment
  has_many :add_on_payments
  has_many :payments, through: :add_on_payments

  validates(:name, presence: true)
  validates(:cost, presence: true)
  validates(:description, presence: true)
  validates(:addon_type, presence: true)
end
