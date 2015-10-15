class AnalyticsController < ApplicationController
  before_action :check_has_analytics_access

  def index
    # Deal Statistics by Deals
    deal_statistics_by_deal
  end

  def venue
    # Deal Statistics by Venues
    deal_statistics_by_venue
    render "analytics/venue"
  end

  def trends
    aggregate_trends
    render"analytics/trends"
  end

  # Check if user has the subscribed to any deal analytics addons
  private
  def check_has_analytics_access
    @payment = MerchantService.get_deal_analytics(merchant_id)
    if (@payment.blank? || (!@payment.paid?))
      render "analytics/error"
    end
    @payment
  end

  private
  def check_has_deal_statistics
    payment = MerchantService.has_deal_statistics(merchant_id)
    if payment.blank?
      false
    else
      true
    end
  end

  private
  def check_has_aggregate_trends
    payment = MerchantService.has_aggregate_trends(merchant_id)
    if payment.blank?
      false
    else
      true
    end
  end

  # Helper methods
  def deal_statistics_by_deal
    if check_has_deal_statistics
      # Show view count and redemption count in highchart by days
      deal_analytics_by_day
      # Show popular deal type
      deal_analytics_by_type_and_redemption
    else
      render "analytics/error"
    end
  end

  def deal_statistics_by_venue
    if check_has_deal_statistics
      # Show popularity of venue
      deal_analytics_by_venue
      # Show popularity of deals in venue
      deal_analytics_by_deals_for_venues
    else
      render "analytics/error"
    end
  end

  def aggregate_trends
    if check_has_aggregate_trends
      get_top_active_deals
      get_top_queries
      get_overall_popular_deal_type
    else
      render "analytics/error"
    end
  end

  private
  def deal_analytics_by_day
    @deals_daily_count = DealAnalyticService.get_analytics_for_line_graph(merchant_id, Date.today.beginning_of_quarter, Date.today)
  end

  private
  def deal_analytics_by_type_and_redemption
    @deals_popularity_by_type_and_redemption = DealAnalyticService.get_analytics_for_deals_pie_chart(merchant_id)
  end

  private
  def deal_analytics_by_venue
    @deals_by_venue = DealAnalyticService.get_analytics_for_deals_by_venue(merchant_id)
  end

  private
  def deal_analytics_by_deals_for_venues
    @deals_for_venue = DealAnalyticService.get_analytics_for_venues_by_deals(merchant_id)
  end

  private
  def get_top_active_deals
    @top_deals = DealAnalyticService.get_top_active_deals
  end

  private
  def get_top_queries
    @top_query = DealAnalyticService.get_top_queries
  end

  private
  def get_overall_popular_deal_type
    @popular_deal_type = DealAnalyticService.get_overall_popular_deal_type
  end
end