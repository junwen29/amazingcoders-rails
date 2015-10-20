class RedemptionService

  module ClassMethods
    def validate(deal_id, user_id, venue_id)
      deal = Deal.find(deal_id)
      redeemable = deal.redeemable
      multiple_redeem = deal.multiple_use

      return nil unless redeemable

      redemption = Redemption.where(user_id: user_id, deal_id: deal_id, venue_id: venue_id).first
      never_redeem_before = redemption.blank?

      if never_redeem_before
        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
        Deal.increment_counter(:num_of_redeems, deal_id)
      elsif multiple_redeem
        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
        Deal.increment_counter(:num_of_redeems, deal_id)
      end

      return redemption

    end

    def get_redemptions_by_user_id(user_id)
      Redemption.where(user_id: user_id)
    end

  end

  class << self
    include ClassMethods
  end

end