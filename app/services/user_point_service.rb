class UserPointService

  module ClassMethods

    def new_point(reason, point, operation, user_id)
      p = UserPoint.new
      p.reason = reason
      p.points = point
      p.operation = operation
      p.user_id = user_id
      p.save

      user = User.find(user_id)
      user.notifications.create(item_type: 'user_point',
                                item_id: p.id,
                                item_name: reason,
                                message: 'Congratulations, you have been awarded ' + point.to_s + ' burps!')

      return p
    end

  end

  class << self
    include ClassMethods
  end
end