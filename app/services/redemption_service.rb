class RedemptionService

  module ClassMethods
    # error code {
    # 1: nil => no such Active deal
    # 2: invalid deal period
    # 3: redeem before TODO change RedeemError.new
    # }

    def validate(deal_id, user_id, venue_id)
      deal = Deal.find(deal_id)
      error = RedeemExistsError.new unless deal.present? # invalid QR code
      return nil, error unless deal.present?

      deal = Deal.active.find(deal_id) # TODO check for active deal, deal_days, time
      redeemable = deal.redeemable
      # error = nil
      error = RedeemActiveError.new unless deal.present? # deal is not active
      # valid_time = deal.valid_time
      return nil,error unless redeemable && deal.present?

      multiple_redeem = deal.multiple_use

      redemption = Redemption.where(user_id: user_id, deal_id: deal_id, venue_id: venue_id).first
      never_redeem_before = redemption.blank?

      if never_redeem_before
        # award burps
        venue = Venue.find(venue_id)
        #eg. title =  'Salmon deal at Salmon Village'
        point = UserPointService.new_point('Redeemed '+ deal.title.to_s + '@ ' + venue.name.to_s, '5'.to_i, "Credit", user_id)

        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id, user_point_id: point.id)
        Deal.increment_counter(:num_of_redeems, deal_id)

        return redemption, error
      elsif multiple_redeem #redeem before but deal allows more than 1 redeem
        redemption = Redemption.create(deal_id: deal_id, user_id: user_id, venue_id: venue_id)
        Deal.increment_counter(:num_of_redeems, deal_id)
        return redemption, error
      else #redeem before so cannot redeem return nil
        # error = 1
        return nil, nil
      end
    end

    def get_redemptions_by_user_id(user_id)
      Redemption.where(user_id: user_id).order("created_at DESC")
    end

    def count_all_redemptions(start_date, end_date)
      redemptions = Redemption.where('created_at >= ? AND created_at <= ?', start_date, end_date)
      redemptions.count
    end

    def count_uniq_redemptions(deal_id, user_id = nil, date = nil)
      if user_id == nil
        if date == nil
          Redemption.where(deal_id: deal_id).select(:user_id).distinct.count
        else
          date = date.to_datetime.in_time_zone("Singapore").end_of_day
          Redemption.where(deal_id: deal_id).where('created_at <= ?', date).select(:user_id).distinct.count
        end
      else
        if date == nil
          Redemption.where(deal_id: deal_id).where(user_id: user_id).select(:user_id).distinct.count
        else
          date = date.to_datetime.in_time_zone("Singapore").end_of_day
          Redemption.where(deal_id: deal_id, user_id: user_id).where('created_at <= ?',date).select(:user_id).distinct.count
        end
      end
    end

    def num_users_multiple(deal_id, date = nil)
      # When this occurs it means that each user has only one redeem so there won't be any multiple redeems left
      if date == nil
        user_ids = Redemption.where(deal_id: deal_id).select(:user_id).distinct.pluck(:user_id)
        total_redemptions = Redemption.where(deal_id: deal_id, user_id: user_ids).count
      else
        date = date.to_datetime.in_time_zone("Singapore").end_of_day
        user_ids = Redemption.where(deal_id: deal_id).where('created_at <= ?', date).select(:user_id).distinct.pluck(:user_id)
        total_redemptions = Redemption.where(deal_id: deal_id, user_id: user_ids).where('created_at <= ?', date).count
      end
      num_users = 0
      total_users = user_ids.count
      if date == nil
        user_ids.each do |ui|
          if total_users == total_redemptions
            break
          end
          user_redemption = Redemption.where(deal_id: deal_id, user_id: ui).count
          if user_redemption > 1
            num_users = num_users + 1
          end
          total_redemptions = total_redemptions - user_redemption
          total_users = total_users - 1
        end
      else
        if total_redemptions != total_users
          user_ids.each do |ui|
            # When this occurs it means that each user has only one redeem so there won't be any multiple redeems left
            if total_users == total_redemptions
              break
            end
            user_redemption = Redemption.where(deal_id: deal_id, user_id: ui).where('created_at <= ?', date).count
            if user_redemption > 1
              num_users = num_users + 1
            end
            total_redemptions = total_redemptions - user_redemption
            total_users = total_users - 1
          end
        end
      end
      num_users
    end

    # Returns array of unique user_ids who redeem the deal
    # If multiple_redeem = true, get only user_ids of those who redeem multiple times
    def get_user_ids(deal_id, multiple_redeem = false)
      date = DateTime.now.in_time_zone("Singapore").end_of_day
      if multiple_redeem
        user_ids = Array.new
        all_users = Redemption.where(deal_id: deal_id).where("created_at <= ?", date).select(:user_id).distinct.pluck(:user_id)
        all_users.each do |au|
          if Redemption.where(deal_id: deal_id, user_id: au).count > 1
            user_ids << au
          end
        end
        user_ids
      else
        Redemption.where(deal_id: deal_id).where("created_at <= ?", date).select(:user_id).distinct.pluck(:user_id)
      end
    end

    def get_average_days_between_redeems(deal_id, user_ids)
      total_days = 0
      total_redemption = 0
      date = DateTime.now.in_time_zone("Singapore").end_of_day
      user_ids.each do |ui|
        maximum_date = Redemption.where(deal_id: deal_id, user_id: ui).where("created_at <= ?", date).maximum(:created_at).to_date
        minimum_date = Redemption.where(deal_id: deal_id, user_id: ui).where("created_at <= ?", date).minimum(:created_at).to_date
        total_days = total_days + (maximum_date - minimum_date).to_i
        total_redemption = total_redemption + Redemption.where(deal_id: deal_id, user_id: ui).where("created_at <= ?", date).count - 1
      end
      average = ((total_days.to_f)/(total_redemption.to_f))
      average.round(2)
    end

  end

  class << self
    include ClassMethods
  end

end