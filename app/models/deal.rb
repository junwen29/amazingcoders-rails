class Deal < ActiveRecord::Base
  has_many :deal_days, :dependent => :destroy
  accepts_nested_attributes_for :deal_days, allow_destroy: true


  validates(:name_of_deal, presence: true)
  validates(:type_of_deal, presence: true)
  validates(:description,presence: true, length: {minimum: 5})
  validates(:start_date, presence: true)
  validates(:expiry_date, presence: true)
  validates(:location, presence: true)
  validates(:t_c, presence: true)
  validates(:redeemable, :inclusion => {:in => [true, false]})
  validate :check_expiry_date
  validate :check_hidden_redeemable_fields
  validate :future_date

  def check_hidden_redeemable_fields
    errors.add(:redeemable, 'Please select one option') if ((redeemable == nil) rescue ArgumentError == ArgumentError)
    if (redeemable)
      errors.add(:multiple_use, 'Please select one option') if ((multiple_use == nil) rescue ArgumentError == ArgumentError)
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end

  def future_date
    errors.add(:start_date, 'Minimally require one day in advance') if ((start_date <= Date.today) rescue ArgumentError == ArgumentError)
  end

  def check_expiry_date
    errors.add(:expiry_date, 'Expiry date has to be after start date') if ((expiry_date <= start_date) rescue ArgumentError == ArgumentError)
  end

end
