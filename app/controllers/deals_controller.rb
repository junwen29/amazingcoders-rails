class DealsController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  before_action :check_has_deal_access
  before_action :set_deal, only: [:show, :edit, :update, :destroy, :activate, :push]

  def new
    @all_venues = MerchantService.get_all_venues(merchant_id)
    if @all_venues.blank?
      flash[:error] = "Please ensure you have listed a venue before proceeding"
      redirect_to deals_path
    else
      @deal = Deal.new
      @deal_venue = @deal.deal_venues.build
      deal_day = @deal.deal_days.build
      deal_day.deal_times.build
    end
  end

  def edit
    # For drop down form
    @all_venues = MerchantService.get_all_venues(merchant_id)
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
    @all_venues = MerchantService.get_all_venues(merchant_id)
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
      flash[:success] = "Deal successfully created!"
      redirect_to @deal
      # Send out confirmation email
      # DealMailer.deal_email("Test Food Merchant", @deal, MerchantService.get_email(merchant_id)).deliver
    else
      flash[:error] = "Failed to create deal!"
      render 'new'
    end
  end

  def update
    # For drop down form
    @all_venues = MerchantService.get_all_venues(merchant_id)
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
      # Send out update email
      # DealMailer.update_deal_email("Test Food Merchant", @deal, MerchantService.get_email(merchant_id)).deliver
      redirect_to @deal
    else
      flash[:error] = "Failed to update deal!"
      render 'edit'
    end
  end

  def show
    @qr = RQRCode::QRCode.new(@deal.id.to_s + "_" + @deal.created_at.to_s).to_img.resize(200, 200).to_data_url
    respond_to do |format|
      format.html
      if @deal.redeemable
        format.pdf do
          pdf = QrcodePdf.new(@deal)
          send_data pdf.render, filename: "QRCodes_of_#{@deal.title}.pdf", type: "application/pdf"
        end
      end
    end
  end

  def destroy
    @deal.destroy
    flash[:success] = "Deal deleted!"
    #need not add a view for this action since redirecting to the index
    #action
    redirect_to deals_path
  end

  # Change non-active deal to active
  def activate
    num_active_deals = DealService.num_active_deals(@deal.merchant_id, @deal)
    if num_active_deals >= 5
      flash[:error] = "As you currently have more than 5 active deals this process can not be processed!"
    elsif
      @deal.update_attribute(:active, true)
      flash[:success] = "Deal has been successfully activated! If you require to edit or delete the deal please email Burpple for admin help."
    end
    redirect_to deals_path
  end

  # Change non-active deal to active
  def push
    @deal.update_attribute(:pushed, true)
    flash[:success] = "Deal has been successfully pushed to wishlisted users"
    redirect_to deals_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deal
    @deal = Deal.find(params[:id])
  end

  # Check if user has the subscribed to deal listing plan
  private
  def check_has_deal_access
    @payment = MerchantService.get_deal_plan(merchant_id)
    if (@payment.blank?)
      render "deals/error"
    end
    @payment
  end

  private
  def deal_params
    params.require(:deal).permit(:title, :redeemable, :multiple_use, :image, :type_of_deal, :description, :start_date,
                                 :expiry_date, :location, :t_c, :pushed, :active,
                                 deal_days_attributes: [:id, :mon, :tue, :wed, :thur, :fri, :sat, :sun, :_destroy,
                                                        deal_times_attributes: [:id, :started_at, :ended_at, :_destroy]],
                                 deal_venues_attributes: [:id, :qrCodeLink], venues_attributes: [:id, :location])
  end

end

