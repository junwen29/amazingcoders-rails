class UserFeedback < ActiveRecord::Base

  belongs_to :user

  validates(:title, presence: true)
  validates(:category, presence: true)
  validates(:content,presence: true)

end
