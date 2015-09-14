class MerchantPagesController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  def home
    @merchant_page = true
    @html_title = "Amazing Coders - Home"

    if merchant_signed_in?
      redirect_to venues_path
    end

  end

end
