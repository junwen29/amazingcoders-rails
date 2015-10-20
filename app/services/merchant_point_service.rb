class MerchantPointService

  module ClassMethods

    def new_point(reason, point, operation, merchant_id)
      p = MerchantPoint.new
      p.reason = reason
      p.points = point
      p.operation = operation
      p.merchant_id = merchant_id
      p.save
    end
  end

  class << self
    include ClassMethods
  end
end
