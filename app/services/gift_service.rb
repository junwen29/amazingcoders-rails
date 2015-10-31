class GiftService

  module ClassMethods

    def check_redeemable(merchant_id, gift)
      @merchant = Merchant.find(merchant_id)
      points = Merchant.find(merchant_id).total_points

      points >= gift.points

    end
  end

  class << self
    include ClassMethods
  end
end
