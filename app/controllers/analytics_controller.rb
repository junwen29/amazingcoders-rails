class AnalyticsController < ApplicationController
  before_action :check_has_analytics_access

  def index
    @deals_names = MerchantService.get_all_active_deals(merchant_id).pluck(:title)
    @deals_ids = MerchantService.get_all_active_deals(merchant_id).pluck(:id)

    # Get view counts and redemption counts for all deals
    @view_counts = Array.new
    @redemption_counts = Array.new
    @deals_ids.each do |id|
      @view_counts.push DealAnalytic.get_view_count(id)
      @redemption_counts.push DealAnalytic.get_redemption_count(id)
    end

    #raise @redemption_counts.inspect
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