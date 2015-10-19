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

    def createRedemption(deal_id, user_id, venue_id)
      deal = Deal.find(deal_id)
      redeemable = deal.redeemable
      multiple_redeem = deal.multiple_use

      return nil unless redeemable

      redemption = Redemption.where(user_id: user_id, deal_id: deal_id, venue_id: venue_id).first
      never_redeem_before = redemption.blank?

      if never_redeem_before
        Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
      elsif multiple_redeem
        Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
      end

    end

    def getRedemptionsByUserId(user_id)
      Redemption.where(user_id: user_id)
    end

  end

  class << self
    include ClassMethods
  end

end