class UserFeedback < ActiveRecord::Base

  include UserFeedback::Json

  belongs_to :user

  validates(:title, presence: true)
  validates(:category, presence: true)
  validates(:content,presence: true)

  scope :resolved, -> {where("resolved = ?", true)}
  scope :unresolved, -> {where("resolved = ?", false)}

end
