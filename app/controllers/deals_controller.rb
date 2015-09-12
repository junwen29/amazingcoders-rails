class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  def new
    @deal = Deal.new
    @deal_venue = @deal.deal_venues.build
    deal_day = @deal.deal_days.build
    deal_day.deal_times.build
    @all_venues = Venue.all
  end

  def edit
    # For drop down form
    @all_venues = Venue.all
    @deal_venue = @deal.deal_venues.build

    # Get all venue locations from this merchant
    @locations = Venue.pluck(:neighbourhood)
  end

  def index
    @deals = MerchantService.get_all_deals(merchant_id)
  end

  def create
    #for database
    @deal = Merchant.find(merchant_id).deals.new(deal_params)

    # Get all venue locations from this merchant
    @locations = Venue.pluck(:neighbourhood)
    # For drop down form
    @all_venues = Venue.all
    @deal_venue = @deal.deal_venues.build

    # Add venue_id to deal_venue join table
    venues_arr = params[:venues][:id].drop(1)     # pop out initial null
    # raise venues_arr.inspect
    venues_arr.each do |venue|
      if !venue.empty?
        @deal.deal_venues.build(:venue_id => venue)
      end
    end

    if @deal.save
      #DealMailer.deal_email("Test Food Merchant", "Deal Listing Service").deliver
      flash[:success] = "Deal successfully created!"
      redirect_to @deal
      # Send out confirmation email
      # DealMailer.deal_email("Test Food Merchant", @deal).deliver
    else
      flash[:error] = "Failed to create deal!"
      render 'new'
    end
  end

  def update

    # For drop down form
    @all_venues = Venue.all
    @deal_venue = @deal.deal_venues.build

    # Find all previous associations in join table and delete them
    @deal_venues = DealVenue.where("deal_id = ?", params[:id])
    @deal_venues.each do |dv|
      dv.destroy
    end

    # Add venue_id to deal_venue join table
    venues_arr = params[:venues][:id].drop(1)     # pop out initial null
    venues_arr.each do |venue|
      if !venue.empty?
        @deal.deal_venues.build(:venue_id => venue)
      end
    end

    if @deal.update(deal_params)
      flash[:success] = "Deal successfully updated!"
      redirect_to @deal
    else
      flash[:error] = "Failed to update deal!"
      render 'edit'
    end
  end

  def show
  end

  def destroy
    @deal.destroy
    flash[:success] = "Deal deleted!"
    #need not add a view for this action since redirecting to the index
    #action
    redirect_to deals_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deal
    @deal = Deal.find(params[:id])
  end

  private
  def deal_params
    params.require(:deal).permit(:title, :redeemable, :multiple_use, :image, :type_of_deal, :description, :start_date,
                                 :expiry_date, :location, :t_c, :pushed,
                                 deal_days_attributes: [:id, :mon, :tue, :wed, :thur, :fri, :sat, :sun, :_destroy,
                                                        deal_times_attributes: [:id, :started_at, :ended_at, :_destroy]],
                                 deal_venues_attributes: [:id, :qrCodeLink], venues_attributes: [:id, :location])
  end
end

