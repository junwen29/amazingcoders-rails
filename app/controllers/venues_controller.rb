class VenuesController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  before_action :set_venue, only: [:show, :edit, :update, :destroy]
  before_action :all_venues

  def index
    @venues = Venue.where(:merchant_id => merchant_id)
  end

  # GET /venues/new
  def new
    @venue = Venue.new
    # Get data required for form
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
    unless session[:merchant_id] == @venue.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to venues_path
      return
    end
    # Get data required for dashboard
    @venues = Venue.all

    # Get data required for form
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Merchant.find(merchant_id).venues.new(venue_params)

    #respond_to do |format|
      if @venue.save
        flash[:success] = "Venue successfully created!"
        redirect_to @venue
        #format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        #format.json { render :show, status: :created, location: @venue }
      else
        flash[:error] = "Failed to create venue!"
        render 'new'
        #format.html { render :new }
        #format.json { render json: @venue.errors, status: :unprocessable_entity }
      #end
    end
  end

  # PATCH/PUT /venues/1
  # PATCH/PUT /venues/1.json
  def update
      if @venue.update(venue_params)
        flash[:success] = "Venue successfully updated!"
        redirect_to @venue
      else
        flash[:error] = "Failed to update venue!"
        render 'new'
      end
  end

  def show
    @venue = Venue.find(params[:id])
    unless session[:merchant_id] == @venue.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to venues_path
      return
    end
    @deals = VenueService.get_active_deals_for_venue(@venue.id).order(title: :asc)
    @payment = MerchantService.get_deal_plan(merchant_id)
    @ranking = DealAnalyticService.get_own_deals_ranking(merchant_id)
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    if VenueService.allow_delete(@venue.id)
      @venue.destroy
      flash[:success] = "Venue deleted!"
      redirect_to venues_path
    else
      flash[:error] = "Venue cannot be deleted as there is a deal that is only associated with this venue. Please delete the deal first or contact Burpple admin for help"
      redirect_to venues_path
    end
  end

  private
  # find all venues
  def all_venues
    @venues = MerchantService.get_all_venues(merchant_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_venue
    @venue = Venue.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def venue_params
    params.require(:venue).permit(:name, :street, :zipcode, :photo, :neighbourhood, :bio,
                                  :phone, :address_2, :contact_number)
  end
end
