class Biz::ApplicationController < ApplicationController
  before_filter :authenticate_merchant!, :set_analytics_id, :set_merchant_id
  
  include Burpple::ControllerHelper
  include Burpple::BizControllerHelper

  def m_id
    current_merchant.id if merchant_signed_in?
  end

  def set_merchant_id
  	@merchant_id = m_id
  end

end
