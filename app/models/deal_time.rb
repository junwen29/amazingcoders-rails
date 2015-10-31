class DealTime < ActiveRecord::Base
  belongs_to :deal_day

  validates :started_at, :presence => {message: "Please ensure you have keyed in a start time"}
  validates :ended_at, :presence => {message: "Please ensure you have keyed in a end time"}
  validate :start_must_be_before_end_time

  private
  def start_must_be_before_end_time
    errors.add(:started_at, " of deal must be before end time") unless
        started_at < ended_at
  end

  def valid_hour (time)
    valid = time > started_at && time < ended_at
  end
end
