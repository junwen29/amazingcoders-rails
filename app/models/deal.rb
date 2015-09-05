class Deal < ActiveRecord::Base
  has_many :venues, through: :deal_venues
  has_many :deal_days, :dependent => :destroy
  accepts_nested_attributes_for :deal_days, allow_destroy: true


  validates(:name_of_deal, presence: true)
  validates(:type_of_deal, presence: true)
  validates(:description,presence: true, length: {minimum: 5})
  validates(:start_date, presence: true)
  validates(:expiry_date, presence: true)
  validate :future_date
  validate :check_expiry_date
  validates :deal_days, :presence => {message: "Please ensure that there is at least one deal period"}
  validates(:location, presence: true)
  validates(:t_c, presence: true)
  validates :pushed, :presence => {message: "Please ensure you selected if you want to push deals to users"}
  validates :redeemable, :presence => {message: "Please ensure you selected if you want users to redeem through deal code"}
  validates :multiple_use, :presence => {message: "Please indicate the number of times the deals can be redeemed per user"}, if: :redeemable?


  def future_date
    errors.add(:start_date, 'must be at least one day in advance') if ((start_date <= Date.today) rescue ArgumentError == ArgumentError)
  end

  def check_expiry_date
    errors.add(:expiry_date, 'has to be after start date') if ((expiry_date <= start_date) rescue ArgumentError == ArgumentError)
  end

end
