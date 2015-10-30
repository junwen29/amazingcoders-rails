class RedemptionService

  module ClassMethods
    # error code {
    # 1: nil => no such Active deal
    # 2: invalid deal period
    # 3: redeem before TODO change RedeemError.new
    # }

    def validate(deal_id, user_id, venue_id)
      deal = Deal.active.find(deal_id) # TODO check for active deal, deal_days, time
      redeemable = deal.redeemable
      error = 1 unless deal.present?
      # valid_time = deal.valid_time
      return nil,error unless redeemable && deal.present?

      multiple_redeem = deal.multiple_use

      redemption = Redemption.where(user_id: user_id, deal_id: deal_id, venue_id: venue_id).first
      never_redeem_before = redemption.blank?

      if never_redeem_before
        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
        Deal.increment_counter(:num_of_redeems, deal_id)
        return redemption, error
      elsif multiple_redeem #redeem before but deal allows more than 1 redeem
        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
        Deal.increment_counter(:num_of_redeems, deal_id)
        return redemption, error
      else #redeem before so cannot redeem return nil
        error = 1
        return nil, error
      end
    end

    def get_redemptions_by_user_id(user_id)
      Redemption.where(user_id: user_id)
    end

    def count_all_redemptions(start_date, end_date)
      redemptions = Redemption.where('created_at >= ? AND created_at <= ?', start_date, end_date)
      redemptions.count
    end

    def count_uniq_redemptions(deal_id, user_id = nil)
      if user_id == nil
        Redemption.where(deal_id: deal_id).select(:user_id).distinct.count
      else
        Redemption.where(deal_id: deal_id).where(user_id: user_id).select(:user_id).distinct.count
      end
    end

  end

  class << self
    include ClassMethods
  end

end