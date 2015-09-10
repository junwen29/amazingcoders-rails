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
    @deal_venues = @deal.deal_venues.all
    @deal_venues.destroy_all
    @deal_venue = @deal.deal_venues.build
    @all_venues = Venue.all
  end

  def index
    @deal = Deal.all
  end

  def create
    #for database
    @deal = Deal.new(deal_params)
    @deal_venue = @deal.deal_venues.build
    @all_venues = Venue.all

    params[:venues][:id].each do |venue|
      if !venue.empty?
        @deal.deal_venues.build(:venue_id => venue)
      end
    end

    respond_to do |format|
      if @deal.save
        format.html { redirect_to @deal, notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
        end
    end
  end

  def update
    params[:venues][:id].each do |venue|
      if !venue.empty?
        @deal.deal_venues.build(:venue_id => venue)
      end
    end
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @venues = @deal.venues
    @qr = RQRCode::QRCode.new(@deal.to_s).to_img.resize(200, 200).to_data_url
  end

  def destroy
    @deal.destroy
    redirect_to deals_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deal
    @deal = Deal.find(params[:id])
  end

  private
  def deal_params
    params.require(:deal).permit(:name_of_deal, :type_of_deal, :description, :start_date, :expiry_date, :location, :t_c,
                                 :pushed,:redeemable, :multiple_use, :image,
                                 deal_days_attributes: [:id, :mon, :tue, :wed, :thur, :fri, :sat, :sun, :_destroy,
                                                        deal_times_attributes: [:id, :started_at, :ended_at, :_destroy]],
    deal_venues_attributes: [:id, :qrCodeLink], venues_attributes: [:id, :location])
  end
end

