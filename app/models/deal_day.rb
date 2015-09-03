class DealDay < ActiveRecord::Base
  belongs_to :deal
  has_many :deal_times, :dependent => :destroy
  accepts_nested_attributes_for :deal_times, allow_destroy: true

  # validate :at_least_one
  validates(:day, presence: true)

  private
  def at_least_one
      errors.add(:day, 'At least one deal period must be listed') if ((deal_times.count < 1) rescue ArgumentError == ArgumentError)
    end
  end
