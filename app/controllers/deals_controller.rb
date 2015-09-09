class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  def new
    @deal = Deal.new

    # For drop down form
    @all_venues = Venue.all
    @deal_venue = @deal.deal_venues.build
    #DealMailer.deal_email("Test Food Merchant", "Deal Listing Service").deliver

    # Get all venue locations from this merchant
    @locations = Venue.pluck(:neighbourhood)

  end

  def edit
    @deal = Deal.find(params[:id])

    # Get all venue locations from this merchant
    @locations = Venue.pluck(:neighbourhood)
  end

  def index
    @deal = Deal.all
  end

  def create
    #for database
    @deal = Deal.new(deal_params)
    @deal_venue = @deal.deal_venues.build
    # Get all venue locations from this merchant
    @locations = Venue.pluck(:neighbourhood)

    # Add venue_id to deal_venue join table
    params[:venues][:id].each do |venue|
      if !venue.empty?
        @deal.deal_venues.build(:venue_id => venue)
      end
    end

    if @deal.save
      redirect_to @deal
      # Send out confirmation email
      # DealMailer.deal_email("Test Food Merchant", @deal).deliver
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
  # Use callbacks to share common setup or constraints between actions.
  def set_deal
    @deal = Deal.find(params[:id])
  end

  private
  def deal_params
    params.require(:deal).permit(:title, :redeemable, :multiple_use, :image,
      :type_of_deal, :description, :start_date, :expiry_date, :location, :t_c, 
      :pushed)
  end
end

