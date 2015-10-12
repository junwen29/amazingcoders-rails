class PointService

  module ClassMethods

    def new_point(reason, burp, operation, merchant_id)
      p = Point.new
      p.reason = reason
      p.burps = burp
      p.operation = operation
      p.merchant_id = merchant_id
      p.save
    end
  end

  class << self
    include ClassMethods
  end
end
