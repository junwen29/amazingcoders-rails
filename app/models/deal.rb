class Deal < ActiveRecord::Base
  # include methods from related modules
  include Deal::Json

  belongs_to :merchant

  has_many :deal_venues, inverse_of: :deal, dependent: :destroy
  has_many :venues, through: :deal_venues
  accepts_nested_attributes_for :deal_venues, allow_destroy: true

  has_many :deal_days, :dependent => :destroy
  accepts_nested_attributes_for :deal_days, allow_destroy: true

  scope :waiting, -> {where("start_date > ?", Date.today)}
  scope :active, -> {where("active = ?", true)}
  scope :expired, -> {where("expiry_date < ?", Date.today)}
  scope :type, -> (type) {where(type_of_deal: type)}

  scope :started, -> {where("start_date <= ? AND expiry_date >= ?", Date.today, Date.today)}
  scope :pushed, -> {where("pushed = ?", true)}

  # For adding images
  has_attached_file :image,
                    :default_url => 'biz/burpple_logo.png'


  # Validate input fields from form
  validates(:title, presence: true)
  validates(:type_of_deal, presence: true)
  validates(:description,presence: true, length: {minimum: 5})
  validates(:start_date, presence: true)
  validates(:expiry_date, presence: true)
  validates(:t_c, presence: true)
  validates :deal_days, :presence => {message: "Please ensure that there is at least one deal period"}
  #validates :deal_venues, :presence => {message: "Please select at least one venue for your deal", models:""}

  validates_attachment_content_type :image, content_type: /\Aimage/

  # Process input fields and further validate
  validate :future_date
  validate :check_expiry_date
  # validate :ensuring_pushed_checked
  validate :ensuring_redeemable_checked
  validate :ensuring_multiple_use_checked
  validate :has_venues
  validate :check_valid_period

  # Process Methods
  def has_venues
    errors.add(:base, 'Please select at least one venue for your deal') if ((deal_venues.blank?) rescue ArgumentError == ArgumentError)
  end

  def ensuring_pushed_checked
    errors.add(:pushed, 'Please ensure you selected if you want to push deals to users') if ((pushed == nil) rescue ArgumentError == ArgumentError)
  end

  def ensuring_redeemable_checked
    errors.add(:redeemable, 'Please ensure you selected if you want users to redeem through deal code') if ((redeemable == nil) rescue ArgumentError == ArgumentError)
  end

  def ensuring_multiple_use_checked
    if (redeemable)
      errors.add(:multiple_use, 'Please indicate the number of times the deals can be redeemed per user') if ((multiple_use == nil) rescue ArgumentError == ArgumentError)
    end
  end

  def future_date
    errors.add(:start_date, 'must be at least one day in advance') if ((start_date <= Date.today) rescue ArgumentError == ArgumentError)
  end

  def check_expiry_date
    errors.add(:expiry_date, 'cannot be before start date') if ((expiry_date < start_date) rescue ArgumentError == ArgumentError)
  end

  def check_valid_period
    errors.add(:blank, 'Deal period is not within the valid dates of your premium service period. Please input a valid period.') if ((valid_period) rescue ArgumentError == ArgumentError)
  end

  def valid_period
    payment = Payment.where(:merchant_id => merchant_id)
    payment.each do |p|
      if DateTime.now.strftime('%Y/%m/%d') >= p.start_date.strftime('%Y/%m/%d') && DateTime.now.strftime('%Y/%m/%d') <= p.expiry_date.strftime('%Y/%m/%d')
        if start_date >= p.start_date && start_date <= p.expiry_date && expiry_date >= p.start_date && expiry_date <= p.expiry_date
          return false
        end
        true
      end
    end
  end

end
