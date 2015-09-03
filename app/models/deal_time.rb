class DealTime < ActiveRecord::Base
  belongs_to :deal_day

  validates_presence_of :started_at
  validates_presence_of :ended_at

end
