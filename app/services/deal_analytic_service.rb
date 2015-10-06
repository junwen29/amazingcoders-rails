class DealAnalyticService

  module ClassMethods
    # TODO: Call these methods on Android to update view count and redemption count
    def get_view_count(deal_id)
      deal_analytics = DealAnalytic.where(:deal_id => deal_id)
      if deal_analytics.empty?
        0
      else
        deal_analytics.pluck(:view_count).to_param.to_i
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
  end

  class << self
    include ClassMethods
  end

end