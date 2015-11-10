class UserPoint < ActiveRecord::Base

  include UserPoint::Json

  belongs_to :user

  after_create :edit_total

  scope :credit, -> {where("operation = ?", 'Credit')}
  scope :debit, -> {where("operation = ?", 'Debit')}

  validate :ensure_no_negative

  def ensure_no_negative
    user = User.find(user_id)
    total_points = user.total_points
    if operation == "Debit"
      total_points -= points
    end
    if total_points < 0
      errors.add(:base, 'User cannot have negative points: ' + total_points.to_s)
    end
  end

  private
  def edit_total
    point = self
    user = User.find(point.user_id)
    total_points = user.total_points
    if point.operation == "Credit"
      total_points += point.points
    elsif point.operation == "Debit"
      total_points -= point.points
    end

    user.update(total_points: total_points)
  end

end
