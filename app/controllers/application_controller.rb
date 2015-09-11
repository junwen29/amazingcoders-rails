class ApplicationController < ActionController::Base
  #before_filter :authenticate_merchant!, except: [:home, :help]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def merchant_id
    current_merchant.id if merchant_signed_in?
  end

  def set_merchant_id
    @merchant_id = merchant_id
  end

end
