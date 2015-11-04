class UserPointService

  module ClassMethods


    def new_user_point(reason, points, operation, user_id)
      u = UserPoint.new
      u.reason = reason
      u.points = points
      u.operation = operation
      u.user_id = user_id
      u.save
    end


  end

  class << self
    include ClassMethods
  end
end