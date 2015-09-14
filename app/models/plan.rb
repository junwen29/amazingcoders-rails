class Plan < ActiveRecord::Base
  has_many :add_ons, dependent: :destroy
  belongs_to :payment
end
