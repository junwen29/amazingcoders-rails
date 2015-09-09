class VenuesController < ApplicationController
  before_action :set_venue, only: [:index, :show, :edit, :update, :destroy]
  before_action :all_venues

  def index
    # Get data required for form
    @select_day_hours_string = "[]".html_safe
  end

  # GET /venues/new
  def new
    @venue = Venue.new
    # Get data required for form
    @select_day_hours_string = "[]".html_safe
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])

    # Get data required for dashboard
    @venues = Venue.all

    # Get data required for form
    @select_day_hours_string = "[]".html_safe
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Merchant.find(merchant_id).venues.new(venue_params)

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render :show, status: :created, location: @venue }
      else
        format.html { render :new }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venues/1
  # PATCH/PUT /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { render :show, status: :ok, location: @venue }
      else
        format.html { render :edit }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue.destroy
    respond_to do |format|
      format.html { redirect_to venues_url, notice: 'Venue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # find all venues
  def all_venues
    @venues = MerchantService.get_all_venues(merchant_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_venue
    unless @venue.present?
      @venue = all_venues.first
    else
      @venue = Venue.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def venue_params
    params.require(:venue).permit(:name, :street, :zipcode,
                                  :city, :city, :state, :country, :neighbourhood, :bio,
                                  :phone, :address_2, :contact_number)
  end
end
