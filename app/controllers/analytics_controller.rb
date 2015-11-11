class AnalyticsController < ApplicationController
  before_action :check_has_analytics_access

  def index
    have_venues = MerchantService.get_all_venues(merchant_id).blank?
    have_deals = MerchantService.get_all_active_and_past_deals(merchant_id).blank?
    if have_venues
      render 'analytics/no_venue_error'
    elsif have_deals
      render 'analytics/no_deal_error'
    else
      # This is to ensure that there is at least one deal with view counts
      have_views = false
      deals = MerchantService.get_all_active_and_past_deals(merchant_id)
      deals.each do |d|
        have_view_count = Viewcount.where(deal_id: d.id).blank?
        if !have_view_count
          have_views = true
          break
        end
      end
      if have_views
        # Deal Statistics by Deals
        deal_statistics_by_deal
      else
        render 'analytics/no_view_error'
      end
    end
  end

  def venue
    if MerchantService.get_all_venues(merchant_id).blank?
      render 'analytics/no_venue_error'
    elsif MerchantService.get_all_active_and_past_deals(merchant_id).blank?
      render 'analytics/no_deal_error'
    elsif MerchantService.get_active_past_redeemable_deals(merchant_id).blank?
      render 'analytics/no_redeemable_deal_error'
    else
      have_redemptions = false
      deals = MerchantService.get_all_active_and_past_deals(merchant_id)
      deals.each do |d|
        if !Redemption.where(deal_id: d.id).blank?
          have_redemptions = true
          break
        end
      end
      if have_redemptions
        # Deal Statistics by Venues
        deal_statistics_by_venue
        render "analytics/venue"
      else
        render 'analytics/no_redeem_error'
      end
    end
  end

  def trends
    aggregate_trends
    render "analytics/trends"
  end

  def show
    @deal = Deal.find(params[:id])
    unless session[:merchant_id] == @deal.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to analytics_path
      return
    end
    individual_deal_statistic
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
      # Show total view count and redemption count in highchart by days
      deal_analytics_by_total
      # Show view count and redemption count in highchart by days
      deal_analytics_by_day
      # Show popular deal type
      deal_analytics_by_type_and_redemption
      # Show analytics table
      deal_analytics_table
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
      get_own_active_deals_ranking
    else
      render "analytics/error"
    end
  end

  def individual_deal_statistic
    if check_has_deal_statistics
      if @deal.pushed
        get_wishlist_to_view
      end
      if @deal.active
        get_view_to_redemption
        get_multiple_redeems
      end
    else
      render "analytics/error"
    end
  end

  private
  def deal_analytics_by_total
    @deals_daily_total = DealAnalyticService.get_analytics_for_line_graph(merchant_id, Date.today.beginning_of_quarter, Date.today)
  end

  private
  def deal_analytics_by_day
    @deals_daily_count = DealAnalyticService.get_analytics_for_line_graph(merchant_id, Date.today.beginning_of_quarter, Date.today, false)
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
  def deal_analytics_table
    @deals = MerchantService.get_all_deals(merchant_id).order(title: :asc)
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
  def get_own_active_deals_ranking
    @own_deals = DealAnalyticService.get_own_deals_ranking(merchant_id)
  end

  private
  def get_top_queries
    @top_query = DealAnalyticService.get_top_queries
  end

  private
  def get_overall_popular_deal_type
    @popular_deal_type = DealAnalyticService.get_overall_popular_deal_type
  end

  private
  def get_wishlist_to_view
    @wishlist_to_view = DealAnalyticService.get_wishlist_to_view(@deal.id)
  end

  private
  def get_view_to_redemption
    @view_to_redemption = DealAnalyticService.get_view_to_redeem_chart(@deal.id)
  end

  private
  def get_multiple_redeems
    @multiple_redeems = DealAnalyticService.get_ratio_multiple_redeems(@deal.id)
  end
end