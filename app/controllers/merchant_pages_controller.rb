class MerchantPagesController < ApplicationController

  def index
    redirect_to deals_path
  end

  def home
    @merchant_page = true
    @html_title = "Amazing Coders - Home"
  end

end
