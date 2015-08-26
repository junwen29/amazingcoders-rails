class DealsController < ApplicationController
  def new
    @deal = Deal.new
  end

  def edit
    @deal = Deal.find(params[:id])
  end

  def index
    @deal = Deal.all
  end

  def create  
    #for database
    @deal = Deal.new(deal_params)

    if @deal.save
      redirect_to @deal
    else
      render 'new'
    end
  end

  def update
    @deal = Deal.find(params[:id])

    if @deal.update(deal_params)
      redirect_to @deal
    else
      render 'edit'
    end
  end

  def show
    @deal = Deal.find(params[:id])
  end

  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy
    #need not add a view for this action since redirecting to the index
    #action
    redirect_to deals_path
  end

  private
  def deal_params
    params.require(:deal).permit(:name_of_deal, :redeemable, :multiple_use, :image,
      :type_of_deal, :description, :start_date, :expiry_date, :location, :t_c, 
      :num_of_redeems, :selected_others, :pushed)
  end
end

