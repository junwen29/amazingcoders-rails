class UserPointService

  module ClassMethods

    def new_point(reason, point, operation, user_id)
      p = UserPoint.new
      p.reason = reason
      p.points = point
      p.operation = operation
      p.user_id = user_id
      p.save
    end

  end

  class << self
    include ClassMethods
  end
end