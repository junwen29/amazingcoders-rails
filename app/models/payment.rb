class Payment < ActiveRecord::Base
  #has_many :plans
  has_many :add_on_payments, dependent: :destroy
  has_many :add_ons, through:  :add_on_payments

  has_many :plan_payments, dependent: :destroy
  has_many :plans, through:  :plan_payments
  has_one :charge
  
  belongs_to :merchant
  
  scope :active, -> {where("start_date <= ? AND expiry_date >= ?", Date.today, Date.today)}
  scope :expired, -> {where("expiry_date < ?", Date.today)}
  scope :paid, -> {where(paid: true)}
end
