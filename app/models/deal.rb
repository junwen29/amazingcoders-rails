class Deal < ActiveRecord::Base
  validates(:name_of_deal, presence: true)
  validates(:type_of_deal, presence: true)
  validates(:description,presence: true, length: {minimum: 5})
  validates(:start_date, presence: true)
  validates(:expiry_date, presence: true)
  validates(:location, presence: true)
  validates(:t_c, presence: true)
  validates(:num_of_redeems, presence: true)
  validate :future_date
  validate :check_expiry_date
  validate :is_number

  def is_number? string
    true if Float(string) rescue false
  end

  def future_date
    errors.add(:start_date, 'Minimally require one day in advance') if ((start_date <= Date.today) rescue ArgumentError == ArgumentError)
  end

  def check_expiry_date
    errors.add(:expiry_date, 'Expiry date has to be after start date') if ((expiry_date <= start_date) rescue ArgumentError == ArgumentError)
  end

  def is_number
    errors.add(:selected_others, 'Number of Redeems keyed in should be in numbers!') if ((!num_of_redeems.match('infinite') && !is_number?(selected_others)) rescue ArgumentError == ArgumentError)
  end
end
