class UserMerchantsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js

  def index
    redirect_to merchant_home_path
  end

  def new

  end

  def show
    @user = UserMerchant.find(params[:id])
  end

end
