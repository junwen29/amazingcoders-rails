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
      gift = Gift.find_by(name: "1 free month")
      new_point("Redeemed 1 free month of Premium Deals Services", gift.points, "Debit", merchant_id)

    end

  end

  class << self
    include ClassMethods
  end
end
