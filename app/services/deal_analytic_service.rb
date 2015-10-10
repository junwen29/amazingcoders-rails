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

    # TODO: Remove method afterwards as it is for seeding data
    def set_view_count(deal_id, increment = 1)
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

    # TODO: Remove method afterwards as it is for seeding data
    def set_unique_view_count(deal_id, increment = 1)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        DealAnalytic.create(deal_id: deal_id, unique_view_count: 1)
      else
        deal_unique_view_count = deal_analytics.pluck(:unique_view_count).to_param.to_i
        deal_id = deal_analytics.pluck(:id).to_param.to_i
        deal_unique_view_count += increment
        deal_analytics.update(deal_id, {unique_view_count: deal_unique_view_count})
      end
    end

    # TODO: Remove method afterwards as it is for seeding data
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
    # array[0] is first deal
    # array[0][0] gives deal title
    # array[0][1] gives start_date in utc format
    # array [0][2] gives array of view count
    # array [0][3] gives array of redemption count
    # array [5] gives array of expired deal names (If have 5 active deals)
    # array [6] gives merchant_id (if have 5 active deals)
    def get_analytics_for_line_graph(merchant_id, deal_name, start_date, end_date)
      array = Array.new
      if deal_name != nil
        deals = Deal.where(('merchant_id = ? AND title = ?'), merchant_id, deal_name)
      else
        deals = MerchantService.get_all_active_and_past_deals(merchant_id)
      end
      deals.each do |ad|
        temp_start_date = start_date
        temp_end_date = end_date
        numView = 0
        numRedemption = 0
        first_view = true
        first_redeem = true
        numViewArray = Array.new
        numRedeemArray = Array.new
        temparray = Array.new
        nothing = [0]

        temparray << ad.title
        temparray << Time.parse(start_date.to_s).to_f * 1000
        while temp_start_date <= temp_end_date

          numView = numView + Viewcount.where(deal_id: ad.id).where(created_at: temp_start_date..temp_start_date.end_of_day).count
          if numView != 0 && first_view
            first_view = false
          end
          if !first_view
            numViewArray << numView
          else
            numViewArray << nothing
          end

          numRedemption = numRedemption + Redemption.where(deal_id: ad.id).where(created_at: temp_start_date..temp_start_date.end_of_day).count
          if numRedemption != 0 && first_redeem
            first_redeem = false
          end
          if !first_redeem
            numRedeemArray << numRedemption
          else
            numRedeemArray << nothing
          end
          temp_start_date = temp_start_date + 1.days
        end
        temparray << numViewArray
        temparray << numRedeemArray
        array << temparray
      end
      expired_deals = MerchantService.get_past_deals(merchant_id).pluck(:title)
      array << expired_deals
      array << merchant_id
      array
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
          redemption_count = DealAnalytic.where(:deal_id => dt.id).pluck(:redemption_count)[0]
          deal_info << redemption_count
          type_array << deal_info
          total_redemption = total_redemption + redemption_count
        end
        type_array << total_redemption
        array << type_array
      end
      array
    end
  end

  class << self
    include ClassMethods
  end

end