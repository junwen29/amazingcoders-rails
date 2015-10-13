class RedemptionService

  module ClassMethods
    # TODO: Call these methods on Android to update redemption count
    def getRedemptionCount(deal_id)
      redemption = Redemption.where(:deal_id => deal_id)
      if redemption.empty?
        0
      else
        redemption.count
      end
    end

    def setRedemptionCount(deal_id, user_id, venue_id)
      Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
    end

  end

  class << self
    include ClassMethods
  end

end