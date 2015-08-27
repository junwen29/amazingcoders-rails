class Deal < ActiveRecord::Base
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
  validate :check_dates_fields
  validate :check_monday
  validate :check_tuesday
  validate :check_wednesday
  validate :check_thursday
  validate :check_friday
  validate :check_saturday
  validate :check_sunday

  def check_hidden_redeemable_fields
    errors.add(:redeemable, 'Please select one option') if ((redeemable == nil) rescue ArgumentError == ArgumentError)
    if (redeemable)
      errors.add(:multiple_use, 'Please select one option') if ((multiple_use == nil) rescue ArgumentError == ArgumentError)
      if (!multiple_use && multiple_use!= nil)
        errors.add(:num_of_redeems, 'Please select one option') if ((num_of_redeems == nil) rescue ArgumentError == ArgumentError)
        if (num_of_redeems == 'others')
          errors.add(:selected_others, 'Number of Redeems keyed in should be in numbers!') if ((!num_of_redeems.match('infinite') && !is_number?(selected_others)) rescue ArgumentError == ArgumentError)
        end
      end
    end
  end

  def check_dates_fields
    errors.add(:monday, 'Please select at least one date') if ((!monday && !tuesday && !wednesday && !thursday &&!friday &&
        !saturday && !sunday) rescue ArgumentError == ArgumentError)
  end

  def check_monday
    if (monday)
      errors.add(:monday_end, 'For Monday please select a end time after start time.') if ((monday_start >= monday_end) rescue ArgumentError == ArgumentError)
    end
  end

  def check_tuesday
    if (tuesday)
      errors.add(:tuesday_end, 'For Tuesday please select a end time after start time.') if ((tuesday_start >= tuesday_end) rescue ArgumentError == ArgumentError)
    end
  end

  def check_wednesday
    if (wednesday)
      errors.add(:wednesday_end, 'For Wednesday please select a end time after start time.') if ((wednesday_start >= wednesday_end) rescue ArgumentError == ArgumentError)
    end
  end

  def check_thursday
    if (thursday)
      errors.add(:thursday_end, 'For Thursday please select a end time after start time.') if ((thursday_start >= thursday_end) rescue ArgumentError == ArgumentError)
    end
  end

  def check_friday
    if (friday)
      errors.add(:friday_end, 'For Friday please select a end time after start time.') if ((friday_start >= friday_end) rescue ArgumentError == ArgumentError)
    end
  end

  def check_saturday
    if (saturday)
      errors.add(:saturday_end, 'For Saturday please select a end time after start time.') if ((saturday_start >= saturday_end) rescue ArgumentError == ArgumentError)
    end
  end

  def check_sunday
    if (sunday)
      errors.add(:sunday_end, 'For Sunday please select a end time after start time.') if ((sunday_start >= sunday_end) rescue ArgumentError == ArgumentError)
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
