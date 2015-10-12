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

  # Validation
  validate :ensure_plan_checked
  validate :ensure_addon1_checked
  validate :ensure_addon2_checked
  validate :ensure_addon3_checked

  validates(:start_date, presence: true)
  validates(:months, presence: true)
  validate :start_date_not_past
  validate :check_overlapping_plans

  # Process Validation Methods
  def ensure_plan_checked
    errors.add(:base, 'Please ensure that you have selected at least 1 premium plan') if ((plan1 != true) rescue ArgumentError == ArgumentError)
  end

  def ensure_addon1_checked
    errors.add(:base, 'Please ensure that you selected if you want Push Notification Addon') if ((plan1)&&(add_on1 == nil) rescue ArgumentError == ArgumentError)
  end

  def ensure_addon2_checked
    errors.add(:base, 'Please ensure that you selected if you want Deal Statistics Addon') if ((plan1)&&(add_on2 == nil) rescue ArgumentError == ArgumentError)
  end

  def ensure_addon3_checked
    errors.add(:base, 'Please ensure that you selected if you want Aggregate Trends Addon') if ((plan1)&&(add_on3 == nil) rescue ArgumentError == ArgumentError)
  end

  def start_date_not_past
    errors.add(:base, 'Start date must start from today onwards') if ((start_date < Date.today) rescue ArgumentError == ArgumentError)
  end

  def check_overlapping_plans
    errors.add(:base, 'You already have a plan in this period') if ((overlapping_payment) rescue ArgumentError == ArgumentError)
  end

  private
  # find number of overlapping payments
  def overlapping_payment
    num = PaymentService.get_overlapping_payments(merchant_id, start_date)
    if num > 0
      true
    else
      false
    end
  end

end
