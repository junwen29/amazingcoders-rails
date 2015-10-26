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

    def create_extend_point(merchant_id)
      gift = Gift.find_by(name: "Extend")
      new_point("Redeemed 1 free month", gift.points, "Minus", merchant_id)

    end

  end

  class << self
    include ClassMethods
  end
end
