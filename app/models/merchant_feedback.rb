class MerchantFeedback < ActiveRecord::Base

  belongs_to :merchant

  validates(:title, presence: true)
  validates(:category, presence: true)
  validates(:content,presence: true)

  scope :resolved, -> {where("resolved = ?", true)}
  scope :unresolved, -> {where("resolved = ?", false)}

end
