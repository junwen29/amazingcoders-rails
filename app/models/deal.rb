class Deal < ActiveRecord::Base
  validates(:description,presence: true, length: {minimum: 5})
end
