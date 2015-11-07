class ApplicationController < ActionController::Base
  #before_filter :authenticate_merchant!, except: [:home, :help]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from AbstractController::ActionNotFound, :with => :not_found


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

end
