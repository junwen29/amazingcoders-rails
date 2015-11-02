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
        # award burps
        venue = Venue.find(venue_id)
        #eg. title =  'Salmon deal at Salmon Village'
        point = UserPointService.new_point(deal.title.to_s + 'at ' + venue.name.to_s, '5'.to_i, "Credit", user_id)

        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id, user_point_id: point.id)
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

  end

  class << self
    include ClassMethods
  end

end