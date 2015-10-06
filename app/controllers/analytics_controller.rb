class AnalyticsController < ApplicationController
  before_action :check_has_analytics_access

  def index
    # TODO: Add all analytics methods
    # Deal Statistics
    deal_statistics
    deal_statistics_deal_type
    # Aggregate Trends

    #raise @past_deal_names.inspect
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
  def deal_statistics
    if check_has_deal_statistics
      # Show view count and redemption count
      deal_statistics_count
      # Show popular deal type
      deal_statistics_deal_type
    end
  end

  def deal_statistics_count
    # Toggle to view active deals or include past deals
    if params[:scope] == "all"
      @active_deal_names = MerchantService.get_all_active_and_past_deals(merchant_id).pluck(:title)
      @active_deal_ids = MerchantService.get_all_active_and_past_deals(merchant_id).pluck(:id)
    else
      @active_deal_names = MerchantService.get_all_active_deals(merchant_id).pluck(:title)
      @active_deal_ids = MerchantService.get_all_active_deals(merchant_id).pluck(:id)
    end

    # Get view counts and redemption counts for active deals
    @view_counts = Array.new
    @redemption_counts = Array.new
    @active_deal_ids.each do |id|
      @view_counts.push DealAnalyticService.get_view_count(id)
      @redemption_counts.push DealAnalyticService.get_redemption_count(id)
    end
  end

  def deal_statistics_deal_type
=begin
    @merchant_deal_types = MerchantService.get_all_deals(merchant_id).pluck('DISTINCT type_of_deal')
    @all_redemption = Array.new
    @merchant_deal_types.each do |type|
      deal_ids = DealService.get_all_ids_by_type_and_merchant(type, merchant_id)
      redemption = DealAnalyticService.get_redemption_count(deal_ids)
      @all_redemption.push redemption
    end
    #raise @all_redemption.inspect
=end
    # Get deal type and redemption counts for chart
    deal_ids = DealService.get_all_ids_by_type_and_merchant("Discount", merchant_id)
    @redemption_discount = DealAnalyticService.get_redemption_count(deal_ids)
    deal_ids = DealService.get_all_ids_by_type_and_merchant("Freebies", merchant_id)
    @redemption_freebies = DealAnalyticService.get_redemption_count(deal_ids)
  end

end