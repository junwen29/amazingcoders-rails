class Plan < ActiveRecord::Base
  has_many :addons, dependent: :destroy
  belongs_to :plan
end
