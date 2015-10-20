class ApplicationController < ActionController::Base
  #before_filter :authenticate_merchant!, except: [:home, :help]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
=begin
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from AbstractController::ActionNotFound, :with => :not_found
=end
  before_action :check_deal_analytics

  def merchant_id
    current_merchant.id if merchant_signed_in?
    @merchant_id = current_merchant.id
  end

  def set_merchant_id
    @merchant_id = merchant_id
  end

  def not_found
    respond_to do |format|
      format.html {render "#{Rails.root}/public/404", :layout => false, :status => 404 }
    end
  rescue ActionController::UnknownFormat
    head :not_found
  end

  # @deal_analytics = 0: No access
  # @deal_analytics = 1: Has deal statistics and deal aggregate trends
  # @deal_analytics = 2: Has deal statistics only
  # @deal_analytics = 3: Has deal aggregate only
  private
  def check_deal_analytics
    @deal_analytics = 0
    if merchant_signed_in?
      payment = Payment.where("merchant_id = ? AND start_date <= ? AND expiry_date >= ? AND paid = ?", merchant_id, Date.today, Date.today, true).last
      if payment.present?
        if payment.add_on2 && payment.add_on3
          @deal_analytics = 1
        elsif payment.add_on2 && !payment.add_on3
          @deal_analytics = 2
        elsif !payment.add_on2 && payment.add_on3
          @deal_analytics = 3
        end
      end
    end
    end

end
