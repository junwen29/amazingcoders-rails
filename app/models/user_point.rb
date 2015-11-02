class UserPoint < ActiveRecord::Base
  belongs_to :user

  after_create :edit_total

  include UserPoint::Json

  scope :credit, -> {where("operation = ?", 'Credit')}
  scope :debit, -> {where("operation = ?", 'Debit')}

  private
  def edit_total
    point = UserPoint.last
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
