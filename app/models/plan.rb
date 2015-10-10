class Plan < ActiveRecord::Base
  has_many :add_ons, dependent: :destroy
  #belongs_to :payment
  has_many :plan_payments
  has_many :payments, through: :plan_payments

  validates(:name, presence: true)
  validates(:cost, presence: true)
  validates(:description, presence: true)
end
