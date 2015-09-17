class MerchantsController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  before_action :authenticate_merchant!
  respond_to :html, :js

  def index
    redirect_to merchant_home_path
  end

  def new

  end

  def show
    @merchant = Mechant.find(params[:id])
  end

end