class DealAnalyticService

  module ClassMethods
    # TODO: Call these methods on Android to update view count and redemption count
    def get_view_count(deal_id)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        0
      else
        total_view_count = 0
        view = deal_analytics.pluck(:view_count)
        view.each do |v|
          total_view_count += v
        end
        total_view_count
      end
    end

    def get_unique_view_count(deal_id)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        0
      else
        total_unique_view_count = 0
        unique_view = deal_analytics.pluck(:unique_view_count)
        unique_view.each do |v|
          total_unique_view_count += v
        end
        total_unique_view_count
      end
    end

    def get_redemption_count(deal_id)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        0
      else
        total_redemption_count = 0
        redemption = deal_analytics.pluck(:redemption_count)
        redemption.each do |r|
          total_redemption_count += r
        end
        total_redemption_count
      end
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
    # array[0][0][1] gives start_date in utc format
    # array [0][0][2] gives array of view count
    # array [0][0][3] gives array of redemption count
    # array [2] gives array of expired deal names
    def get_analytics_for_line_graph(merchant_id, start_date, end_date)
      array = Array.new
      active_deals = MerchantService.get_all_active_deals(merchant_id)
      past_deals = MerchantService.get_past_deals(merchant_id)
      active_deals_array = get_view_and_redemption_count_by_day(active_deals, start_date, end_date)
      past_deals_array = get_view_and_redemption_count_by_day(past_deals, start_date, end_date)
      expired_deals = past_deals.pluck(:title)
      array << active_deals_array
      array << past_deals_array
      array << expired_deals
      array
    end

    # Returns an array of all deals view and redemption count from start to end date by day
    def get_view_and_redemption_count_by_day(deals, start_date, end_date)
      overall_deals_array = Array.new
      deals.each do |d|
        num_view = 0
        temp_start_date = start_date
        num_redemption = 0
        first_view = true
        first_redeem = true
        num_view_array = Array.new
        num_redeem_array = Array.new
        deal_array = Array.new
        nothing = [0]

        deal_array << d.title
        deal_array << Time.parse(start_date.to_s).to_f * 1000
        while temp_start_date <= end_date

          num_view = num_view + Viewcount.where(deal_id: d.id).where(created_at: temp_start_date..temp_start_date.end_of_day).count
          if num_view != 0 && first_view
            first_view = false
          end
          if !first_view
            num_view_array << num_view
          else
            num_view_array << nothing
          end

          num_redemption = num_redemption + Redemption.where(deal_id: d.id).where(created_at: temp_start_date..temp_start_date.end_of_day).count
          if num_redemption != 0 && first_redeem
            first_redeem = false
          end
          if !first_redeem
            num_redeem_array << num_redemption
          else
            num_redeem_array << nothing
          end
          temp_start_date = temp_start_date + 1.days
        end
        deal_array << num_view_array
        deal_array << num_redeem_array
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
      deals = MerchantService.get_all_active_and_past_deals(merchant_id)
      unique_deal_type = deals.uniq.pluck(:type_of_deal)
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
      venues = Venue.where(:merchant_id => merchant_id)
      venues.each do |v|
        venue_array = Array.new
        venue_total_redemption_count = 0
        venue_array << v.name
        deals = VenueService.get_active_and_past_deals_for_venue(v.id)
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
      active_deals = MerchantService.get_all_active_deals(merchant_id)
      past_deals = MerchantService.get_past_deals(merchant_id)
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
        venues = DealService.get_all_venues(d.id)
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

    def get_top_active_deals(limit = 10)
      active_deals = DealService.get_active_deals.pluck(:id)
      top_10_deal_ids = DealAnalytic.where(deal_id: active_deals).order(redemption_count: :desc).limit(limit).pluck(:deal_id)
      top_active_deals = Deal.find(top_10_deal_ids)
      top_active_deals
    end

    def get_top_queries(limit = 10)
      top_user_queries = UserQuery.order(num_count: :desc).limit(limit)
      top_user_queries
    end

    # array[0] gives first deal_type
    # array[0][0] gives deal_type name
    # array[0][1] gives deal_type_total_average_redemption
    def get_overall_popular_deal_type
      all_active_past_deals = Deal.active_and_expired
      unique_deal_type = all_active_past_deals.uniq.pluck(:type_of_deal)
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
      all_active_past_deals = Deal.active_and_expired
      unique_deal_type = all_active_past_deals.uniq.pluck(:type_of_deal)
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
        total_vc.push get_all_viewcounts(start_date, start_date.next_week)
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

    def get_hint_message_for_top_queries
      top_queries = DealAnalyticService.get_top_queries
      top_queries_display = "In order to aid you in creating a deal, here are some popular keywords users search for: "
      index = 1
      top_queries.each do |tq|
        top_queries_display = top_queries_display + " " + index.to_s + ")" + tq.query
        index = index + 1
      end
      top_queries_display
    end

    def get_hint_for_popular_deal_type
      top_deal_type = DealAnalyticService.get_most_popular_deal_type
      deal_type = "The most popular deal type is " +  top_deal_type[0] + " with an average redemption rate of " + top_deal_type[1].to_s
    end
  end

  class << self
    include ClassMethods
  end

end