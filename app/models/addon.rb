class Addon < ActiveRecord::Base
  belongs_to :plan
  has_many :payments, through: :plan
end
