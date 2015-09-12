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

end
