class DealDay < ActiveRecord::Base
  belongs_to :deal
  has_many :deal_times, :dependent => :destroy
  accepts_nested_attributes_for :deal_times, allow_destroy: true

  validates :deal_times, :presence => {message: "Please ensure that there is at least one time period for your deal"}
  validate :at_least_one_day_selected

  private
  def at_least_one_day_selected
    errors.add(:mon, "Please ensure you select at least one day where your deal is offered") if
        !(mon || tue ||wed || thur || fri || sat || sun)
  end

  #check if day matches any of the deal's day, pass in a day string
  def check_day(day)
    day_string = day.to_s.downcase
    valid = false
    case day_string
      when 'mon'
        valid = self.mon

      when 'tue'
        valid = self.tue

      when 'wed'
        valid = self.wed

      when 'thu'
        valid = self.thur

      when 'fri'
        valid = self.fri

      when 'sat'
        valid = self.sat

      when 'sun'
        valid = self.sun
    end

    return valid

  end

end
