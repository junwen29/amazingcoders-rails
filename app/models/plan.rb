class Plan < ActiveRecord::Base
  has_many :add_on, dependent: :destroy
  belongs_to :plan
end
