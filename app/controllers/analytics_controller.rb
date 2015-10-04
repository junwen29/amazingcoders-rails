class AnalyticsController < ApplicationController
  before_action :check_has_analytics_access

  def index
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
      @view_counts.push DealAnalytic.get_view_count(id)
      @redemption_counts.push DealAnalytic.get_redemption_count(id)
    end

    #raise @past_deal_names.inspect
  end

  # Check if user has the subscribed to deal listing plan
  private
  def check_has_analytics_access
    @payment = MerchantService.get_deal_analytics(merchant_id)
    if (@payment.blank? || (!@payment.paid?))
      render "analytics/error"
    end
    @payment
  end

end