class DealAnalytic < ActiveRecord::Base
  belongs_to :deal

  scope :popular, -> {order(redemption_count: :desc).limit(10)}
end
