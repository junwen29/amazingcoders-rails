class DealAnalyticService

  module ClassMethods
    def get_view_count(deal_id)
      DealAnalytic.where(:deal_id => deal_id).pluck(:view_count).sum
    end

    def get_unique_view_count(deal_id)
      DealAnalytic.where(:deal_id => deal_id).pluck(:unique_view_count).sum
    end

    def get_redemption_count(deal_id)
      DealAnalytic.where(:deal_id => deal_id).pluck(:redemption_count).sum
    end

    def add_view_count(deal_id, increment = 1)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        DealAnalytic.create(deal_id: deal_id, view_count: 1)
      else
        deal_view_count = deal_analytics.pluck(:view_count).to_param.to_i
        deal_id = deal_analytics.pluck(:id).to_param.to_i
        deal_view_count += increment
        deal_analytics.update(deal_id, {view_count: deal_view_count})
      end
    end

    def update_unique_view_count(user_id, deal_id)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id).first
      if deal_analytics.nil?
        DealAnalytic.create(deal_id: deal_id, unique_view_count: 1)
      else
        view_count = Viewcount.where(:deal_id => deal_id, :user_id => user_id).first
        if view_count.nil?
          deal_analytics.increment(:unique_view_count).save
        end
      end
    end

    def set_redemption_count(deal_id, increment = 1)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        DealAnalytic.create(deal_id: deal_id, redemption_count: 1)
      else
        deal_redemption_count = deal_analytics.pluck(:redemption_count).to_param.to_i
        deal_id = deal_analytics.pluck(:id).to_param.to_i
        deal_redemption_count += increment
        deal_analytics.update(deal_id, {redemption_count: deal_redemption_count})
      end
    end

    # This method return a 2d array of active deals and their view count and redemption count for usage in analytics graph
    # Each data is sorted by day
    # array[0] is active deals
    # array[1] is past deals
    # array[0][0] is first active deal
    # array[0][0][0] gives deal title
    # array[0][0][1] gives start_date of redemption count in utc format
    # array [0][0][2] gives array of view count
    # array [0][0][3] gives array of redemption count
    # array [0][0][4] gives start_date of view count in utc format
    # array [2] gives array of expired deal names
    def get_analytics_for_line_graph(merchant_id, start_date, end_date, total = true)
      array = Array.new
      active_deals = MerchantService.get_active_deals_that_are_active_between_two_dates(merchant_id, start_date, end_date).order(title: :asc)
      past_deals = MerchantService.get_past_deals_that_are_active_between_two_dates(merchant_id, start_date, end_date).order(title: :asc)
      active_deals_array = get_view_and_redemption_count_by_day(active_deals, start_date, end_date, total)
      past_deals_array = get_view_and_redemption_count_by_day(past_deals, start_date, end_date, total)
      expired_deals = past_deals.pluck(:title)
      array << active_deals_array
      array << past_deals_array
      array << expired_deals
      array
    end

    # Returns an array of all deals view and redemption count from start to end date by day
    def get_view_and_redemption_count_by_day(deals, start_date, end_date, total)
      overall_deals_array = Array.new
      deals.each do |d|
        num_view_array = Array.new
        num_redeem_array = Array.new
        deal_array = Array.new
        view_start_date = Viewcount.where(:deal_id => d.id).order(created_at: :asc).first
        if view_start_date.blank?
          view_start_date = DateTime.now.in_time_zone("Singapore").beginning_of_day
        else
          view_start_date = view_start_date.created_at.beginning_of_day
        end
        temp = view_start_date

        # If start date of deal is after given start date, we will start from deal start date
        if d.start_date > start_date
          redemption_start_date = d.start_date.in_time_zone("Singapore").beginning_of_day
        else
          redemption_start_date = start_date.in_time_zone("Singapore").beginning_of_day
        end

        # If end date of deal is before given end date, we will end at deal end date
        if d.expiry_date < end_date
          temp_end_date = d.expiry_date.in_time_zone("Singapore").end_of_day
        else
          temp_end_date = end_date.in_time_zone("Singapore").end_of_day
        end

        deal_array << d.title
        deal_array << Time.parse((redemption_start_date).to_s).to_f * 1000

        if total
          while view_start_date <= temp_end_date
          num_view_array << Viewcount.where(deal_id: d.id).where(created_at: d.created_at..view_start_date.to_datetime.in_time_zone("Singapore").end_of_day).count
          view_start_date = view_start_date + 1.days
          end

          while redemption_start_date <= temp_end_date
            num_redeem_array << Redemption.where(deal_id: d.id).where(created_at: d.created_at..redemption_start_date.to_datetime.in_time_zone("Singapore").end_of_day).count
            redemption_start_date = redemption_start_date + 1.days
          end
        else
          while view_start_date <= temp_end_date
            num_view_array << Viewcount.where(deal_id: d.id).where(created_at: view_start_date.beginning_of_day..view_start_date.to_datetime.in_time_zone("Singapore").end_of_day).count
            view_start_date = view_start_date + 1.days
          end

          while redemption_start_date <= temp_end_date
            num_redeem_array << Redemption.where(deal_id: d.id).where(created_at: redemption_start_date.beginning_of_day..redemption_start_date.to_datetime.in_time_zone("Singapore").end_of_day).count
            redemption_start_date = redemption_start_date + 1.days
          end
        end
        deal_array << num_view_array
        deal_array << num_redeem_array
        deal_array << Time.parse((temp).to_s).to_f * 1000
        overall_deals_array << deal_array
      end
      overall_deals_array
    end

    # Returns a nested array
    # array[0] is first deal type. For example array[0] is for all the data of Discounts
    # array[0][0] gives name of deal type. For example Discounts
    # array[0][1] gives is the a deal of type discount
    # array[0][1][0] gives title of deal
    # array[0][1][1] gives redemption count of that deal
    # array[0][last number of array] gives total redemption count for that deal type
    def get_analytics_for_deals_pie_chart(merchant_id)
      array = Array.new
      deals = MerchantService.get_active_past_redeemable_deals(merchant_id)
      unique_deal_type = deals.uniq.pluck(:type_of_deal)
      deals = deals.order(title: :asc)
      unique_deal_type.each do |udt|
        type_array = Array.new
        type_array << udt
        total_redemption = 0
        deal_type = deals.where(:type_of_deal => udt)
        deal_type.each do |dt|
          deal_info = Array.new
          deal_info << dt.title
          analytics = DealAnalytic.where(:deal_id => dt.id).take
          if analytics == nil
            redemption_count = 0
          else
            redemption_count = analytics.redemption_count
          end
          deal_info << redemption_count
          type_array << deal_info
          total_redemption = total_redemption + redemption_count
        end
        type_array << total_redemption
        array << type_array
      end
      array
    end

    # Returns a nested array
    # array[0] is first venue of the merchant that contains all data
    # array[0][0] is the venue name
    # array[0][1] is first deal in the venue
    # array[0][1][0] is the name of first deal
    # array[0][1][1] is the redemption count of the deal
    # array[0][size-1]
    def get_analytics_for_deals_by_venue(merchant_id)
      array = Array.new
      venues = Venue.where(:merchant_id => merchant_id).order(name: :asc)
      venues.each do |v|
        venue_array = Array.new
        venue_total_redemption_count = 0
        venue_array << v.name
        deals = VenueService.get_active_and_past_deals_for_venue_that_are_redeemable(v.id).order(title: :asc)
        deals.each do |d|
          deal_array = Array.new
          deal_array << d.title
          redemption_count = Redemption.where(:venue_id => v.id, :deal_id => d.id).count
          venue_total_redemption_count = venue_total_redemption_count + redemption_count
          deal_array << redemption_count
          venue_array << deal_array
        end
        venue_array << venue_total_redemption_count
        array << venue_array
      end
      array
    end

    # Returns a nested array
    # array[0] is active deals of the merchant
    # array[1] is past deals of the merchant
    # array[0][0] is the first venue of active deal
    # array[0][0][0] is name of the first venue
    # array[0][0][1] is the redemption count of the venue
    # array [0][size -1] is the total redemption count of the deal
    def get_analytics_for_venues_by_deals(merchant_id)
      array = Array.new
      active_deals = MerchantService.get_active_redeemable_deals(merchant_id).order(title: :asc)
      past_deals = MerchantService.get_past_redeemable_deals(merchant_id).order(title: :asc)
      active_deals_array = get_redemption_count_of_each_deal_in_venue(active_deals)
      past_deals_array = get_redemption_count_of_each_deal_in_venue(past_deals)
      array << active_deals_array
      array << past_deals_array
      array
    end

    def get_redemption_count_of_each_deal_in_venue (deal)
      overall_deals_array = Array.new
      deal.each do |d|
        deal_array = Array.new
        deal_total_redemption_count = 0
        deal_array << d.title
        venues = DealService.get_all_venues(d.id).order(name: :asc)
        venues.each do |v|
          venue_array = Array.new
          venue_array << v.name
          redemption_count = Redemption.where(:venue_id => v.id, :deal_id => d.id).count
          venue_array << redemption_count
          deal_total_redemption_count = deal_total_redemption_count + redemption_count
          deal_array << venue_array
        end
        deal_array << deal_total_redemption_count
        overall_deals_array << deal_array
      end
      overall_deals_array
    end

    # Find all active deals between two periods and of a merchant if given.
    # Sort the deals by largest redemption between the two periods to lowest redemption
    # Returns an array of deal_id and redemption count
    def get_active_deals_ranking(start_date, end_date, merchant_id = nil)
      if merchant_id == nil
        active_deals = Deal.where("active = ? AND redeemable = ? AND ((? BETWEEN start_date AND expiry_date) OR (? BETWEEN start_date AND expiry_date))",
                                  true, true, start_date, end_date).pluck(:id)
      else
        active_deals = Deal.where("active = ? AND redeemable = ? AND merchant_id = ? AND ((? BETWEEN start_date AND expiry_date) OR (? BETWEEN start_date AND expiry_date))",
                                  true, true, merchant_id, start_date, end_date).pluck(:id)
      end

      deal_ranking = Array.new
      active_deals.each do |ad|
        deal = Array.new
        deal << ad
        deal << Redemption.where(deal_id: ad).where(created_at: start_date..end_date).count
        deal_ranking << deal
      end
      deal_ranking.sort_by(&:last).reverse
    end

    def get_top_active_deals(limit = 10)
      start_date = Date.today.beginning_of_week
      end_date = Date.today.end_of_day
      get_active_deals_ranking(start_date, end_date).take(limit)
    end

    def get_top_queries(limit = 10)
      top_user_queries = UserQuery.order(num_count: :desc).limit(limit)
      top_user_queries
    end

    def get_own_deals_ranking(merchant_id)
      start_date = Date.today.beginning_of_week
      end_date = Date.today.end_of_day

      last_week_start = start_date - 7.days
      last_week_end = Date.today.end_of_week - 7.days

      top_deals = get_active_deals_ranking(start_date, end_date)
      top_merchant_deals = get_active_deals_ranking(start_date, end_date, merchant_id)
      past_top_deals = get_active_deals_ranking(last_week_start,last_week_end)

      ranking = Array.new
      top_merchant_deals.each do |tmd|
        current_ranking = 0
        deal_ranking = Array.new
        deal_ranking << tmd[0]
        while current_ranking < top_deals.size
          if top_deals[current_ranking][0] == tmd[0]
            deal_ranking << current_ranking + 1
            break
          end
          current_ranking = current_ranking + 1
        end

        past_ranking = 0
        past_top_deals.each do |ptd|
          if tmd[0] == ptd[0]
            deal_ranking << past_ranking + 1 - deal_ranking[1]
            break
          end
          past_ranking = past_ranking + 1
        end
        if deal_ranking[2].blank?
          deal_ranking << 'new'
        end
        ranking << deal_ranking
      end
      ranking.sort{|a,b,c| a[1] <=> b[1]}
    end

    # array[0] gives first deal_type
    # array[0][0] gives deal_type name
    # array[0][1] gives deal_type_total_average_redemption
    def get_overall_popular_deal_type
      all_active_past_deals = Deal.active_and_expired.where(:redeemable => true)
      unique_deal_type = all_active_past_deals.uniq.pluck(:type_of_deal)
      all_active_past_deals = all_active_past_deals.order(title: :asc)
      array = Array.new
      unique_deal_type.each do |udt|
        deal_type_array = Array.new
        deal_type_array << udt
        deal_type = all_active_past_deals.where(:type_of_deal => udt).pluck(:id)
        total_redemption_count = DealAnalytic.where(deal_id: deal_type).sum(:redemption_count)
        total_deals = deal_type.count
        deal_type_array << (total_redemption_count.to_f/total_deals.to_f).round(2)
        array << deal_type_array
      end
      array
    end

    # returns most popular deal type
    def get_most_popular_deal_type
      all_active_past_deals = Deal.active_and_expired.where(:redeemable => true)
      unique_deal_type = all_active_past_deals.uniq.pluck(:type_of_deal)
      all_active_past_deals = all_active_past_deals.order(title: :asc)
      count = 0
      most_popular_deal_type = ""
      unique_deal_type.each do |udt|
        deal_type = all_active_past_deals.where(:type_of_deal => udt).pluck(:id)
        total_redemption_count = DealAnalytic.where(deal_id: deal_type).sum(:redemption_count)
        total_deals = deal_type.count
        total_average_count = (total_redemption_count.to_f/total_deals).round(2)
        if (total_average_count > count)
          count = total_average_count
          most_popular_deal_type = udt
        end
      end
      most_popular_deal = [most_popular_deal_type, count]
    end

    # For admin app traffic analytics
    # return [milliseconds, view count]
    def get_all_viewcounts(start_date, end_date)
      view_counts = Viewcount.where(created_at: start_date..end_date).count
      formatted_vc = Array.new
      formatted_vc.push end_date.to_f * 1000
      formatted_vc.push view_counts
      formatted_vc
    end

    # Get all view counts for each week
    # return data array for deal traffic analytics chart
    def get_app_traffic(start_date, end_date)
      total_vc = Array.new
      while start_date.next_week < end_date
        total_vc.push get_all_viewcounts(start_date.utc, start_date.next_week.utc)
        start_date = start_date.next_week
      end
      total_vc
    end

    # For admin foot traffic analytics
    # return [milliseconds, redemption count]
    def get_all_redemptions(start_date, end_date)
      redemption_counts = Redemption.where(created_at: start_date..end_date).count
      formatted_rc = Array.new
      formatted_rc.push end_date.to_f * 1000
      formatted_rc.push redemption_counts
      formatted_rc
    end

    # Get all redemption counts for each week
    # return data array for deal traffic analytics chart
    def get_foot_traffic(start_date, end_date)
      total_rc = Array.new
      while start_date.next_week < end_date
        total_rc.push get_all_redemptions(start_date, start_date.next_week)
        start_date = start_date.next_week
      end
      total_rc
    end

    def get_hint_message_for_top_queries(limit = 10)
      top_queries = DealAnalyticService.get_top_queries(limit)
      top_queries_display = "To assist you in creating a deal, here are some popular keywords users search for: "
      index = 1
      top_queries.each do |tq|
        top_queries_display = top_queries_display + " (" + index.to_s + ") " + tq.query
        index = index + 1
      end
      top_queries_display
    end

    def get_hint_for_popular_deal_type
      top_deal_type = DealAnalyticService.get_most_popular_deal_type
      deal_type = "The most popular deal type is " + top_deal_type[0] + " with an average redemption rate of " + top_deal_type[1].to_s
    end

    # deal_analytics = 0: No access
    # deal_analytics = 1: Has deal statistics and deal aggregate trends
    # deal_analytics = 2: Has deal statistics only
    # deal_analytics = 3: Has deal aggregate only
    def check_deal_analytics(merchant_id)
      deal_analytics = 0
      payment = Payment.where("merchant_id = ? AND start_date <= ? AND expiry_date >= ? AND paid = ?", merchant_id, Date.today, Date.today, true).last
      if payment.present?
        if payment.add_on2 && payment.add_on3
          deal_analytics = 1
        elsif payment.add_on2 && !payment.add_on3
          deal_analytics = 2
        elsif !payment.add_on2 && payment.add_on3
          deal_analytics = 3
        end
      end
      deal_analytics
    end

    # returns conversion rate of num wishlisters to viewers in percentage
    def get_wishlist_to_views(deal_id)
      push_date = Deal.find(deal_id).push_date
      user_id = WishService.get_user_id(deal_id, push_date)
      num_wishlist = user_id.size
      if num_wishlist == 0
        return 'N/A'
      end
      num_views = Viewcount.where(user_id: user_id, deal_id: deal_id).uniq.where(:entry => 'merchant_push_notification').count.to_f
      conversion = (num_views/num_wishlist)*100
      conversion.round(2)
    end

    # returns conversion rate of num unique views to redeems in percentage
    def get_views_to_redeem(deal_id)
      view_counts = ViewcountService.get_uniq_view_count(deal_id).to_f
      if view_counts == 0
        return 'No Views Yet'
      end
      user_ids = ViewcountService.get_uniq_user_id(deal_id)
      redeem_count = RedemptionService.count_uniq_redemptions(deal_id, user_ids).to_f
      conversion = (redeem_count/view_counts)*100
      conversion.round(2)
    end

    # returns percentage and number of user who redeemed more than once
    # Also returns the user_ids of those who multiple redeem to be used in other functions
    def get_multiple_redeems_percentage(deal_id)
      array = Array.new
      user_count = RedemptionService.get_user_ids(deal_id).count.to_f
      if user_count == 0
        array << 'No Redeems Yet'
        return array
      end
      multiple_redeems = RedemptionService.get_user_ids(deal_id, true)
      percentage = (multiple_redeems.count.to_f/user_count)*100
      array << percentage.round(2)
      array << multiple_redeems.count.to_f.round(0)
      array << multiple_redeems
    end

    # returns average number of redemptions for multiple users
    def average_redemption_multiple_users(deal_id, user_ids = nil)
      if user_ids == nil
        multiple_redeems_user_ids = RedemptionService.get_user_ids(deal_id, true)
      else
        multiple_redeems_user_ids = user_ids
      end
      date = DateTime.now.in_time_zone("Singapore").end_of_day
      multiple_redeems = Redemption.where(deal_id: deal_id, user_id: multiple_redeems_user_ids).where('created_at <= ?', date).count
      if multiple_redeems_user_ids.blank?
        'No Redeems Yet'
      else
        (multiple_redeems.to_f/multiple_redeems_user_ids.count.to_f).round(2)
      end
    end

    # returns average time between users who redeem more than once
    def average_time_btw_multiple_redeem(deal_id, user_ids = nil)
      if user_ids == nil
        multiple_redeems_user_ids = RedemptionService.get_user_ids(deal_id, true)
      else
        multiple_redeems_user_ids = user_ids
      end
      if multiple_redeems_user_ids.blank?
        'No Redeems Yet'
      else
        (RedemptionService.get_average_days_between_redeems(deal_id, multiple_redeems_user_ids).to_s + ' days')
      end
    end

    # returns a nested array
    # array[0] is cumulative increase in percentage per hour
    # array[1] is change in percentage per hour
    def get_wishlist_to_view(deal_id)
      array = Array.new
      cumulative = Array.new
      non_cumulative = Array.new
      push_date = Deal.find(deal_id).push_date.beginning_of_hour.to_datetime
      deal_expiry_date =  Deal.find(deal_id).expiry_date.to_datetime.in_time_zone("Singapore").end_of_day
      end_time = push_date.end_of_hour
      current = DateTime.now.beginning_of_hour + 1.hours

      if (deal_expiry_date - push_date)/1.days <= 7.0
        final = deal_expiry_date
      elsif (current.to_f - push_date.to_f)/1.days > 7.0
        final = push_date + 7.days
      else
        final = current
      end

      num_wishlist = WishService.num_wishlist_deal(deal_id, push_date).to_f
      user_id = WishService.get_user_id(deal_id, push_date)
      num = 0
      while end_time <= final
        num_views = Viewcount.where(user_id: user_id, deal_id: deal_id, :entry => 'merchant_push_notification', created_at: push_date..end_time).count.to_f
        conversion = (num_views/num_wishlist)*100
        cumulative << conversion.round(2)
        if num == 0
          non_cumulative << conversion.round(2)
        else
          non_cumulative << (cumulative[num] - cumulative[num-1])
        end
        num = num + 1
        end_time = end_time + 1.hours
      end
      array << cumulative
      array << non_cumulative
    end

    def get_view_to_redeem_chart(deal_id)
      array = Array.new
      cumulative = Array.new
      non_cumulative = Array.new
      start_date = Deal.find(deal_id).start_date.to_date
      expiry_date = Deal.find(deal_id).expiry_date
      if expiry_date <= Date.today
        end_date = expiry_date
      else
        end_date = Date.today
      end
      if (end_date-start_date).to_i > 30
        start_date = end_date - 1.months
      end
      array << start_date
      num = 0
      while start_date <= end_date
        view_counts = ViewcountService.get_uniq_view_count(deal_id, start_date).to_f
        user_ids = ViewcountService.get_uniq_user_id(deal_id, start_date)
        redeem_count = RedemptionService.count_uniq_redemptions(deal_id, user_ids, start_date).to_f
        conversion = (redeem_count/view_counts)*100
        cumulative << conversion.round(2)
        if num == 0
          non_cumulative << conversion.round(2)
        else
          non_cumulative << (cumulative[num] - cumulative[num-1])
        end
        num = num + 1
        start_date = start_date + 1.days
      end
      array << cumulative
      array << non_cumulative
    end

    def get_ratio_multiple_redeems(deal_id)
      array = Array.new
      cumulative = Array.new
      non_cumulative = Array.new
      start_date = Deal.find(deal_id).start_date
      end_date = Deal.find(deal_id).expiry_date
      if end_date <= Date.today
        stop_date = end_date
      else
        stop_date = Date.today
      end
      if (stop_date-start_date).to_i > 30
        start_date = stop_date - 1.months
      end
      array << start_date
      num = 0
      while start_date <= stop_date
        user_count = RedemptionService.count_uniq_redemptions(deal_id, nil, start_date).to_f
        multiple_redeems = RedemptionService.num_users_multiple(deal_id, start_date).to_f
        percentage = (multiple_redeems/user_count)*100
        cumulative << percentage.round(2)
        if num == 0
          non_cumulative << percentage.round(2)
        else
          non_cumulative << (cumulative[num] - cumulative[num-1])
        end
        num = num + 1
        start_date = start_date + 1.days
      end
      array << cumulative
      array << non_cumulative
    end
  end

  class << self
    include ClassMethods
  end

end