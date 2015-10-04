class AnalyticsController < ApplicationController
  before_action :check_has_analytics_access

  def index

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