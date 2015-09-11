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
    @deal = Deal.all
  end

  def create
    #for database
    @deal = Deal.new(deal_params)
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
      # DealMailer.deal_email("Test Food Merchant", "Deal Listing Service").deliver
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
    @qr = RQRCode::QRCode.new(@deal.id.to_s + "_" + @deal.created_at.to_s).to_img.resize(200, 200).to_data_url
  end

  def destroy
    @deal.destroy
    flash[:success] = "Deal deleted!"
    #need not add a view for this action since redirecting to the index
    #action
    redirect_to deals_path
  end

  def format_days (deal_day)
    deal_days = [deal_day.mon, deal_day.tue, deal_day.wed, deal_day.thur, deal_day.fri, deal_day.sat, deal_day.sun ]
    days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun']
    dealperiod = ""
    i = 0

    while i<7
      # For first day which is selected, no need to put comma
      if deal_days[i] && dealperiod == ""
        dealperiod = dealperiod + days[i]
        # If the string already contains thing, then need put comma
      elsif deal_days[i] && dealperiod != ""
        dealperiod = dealperiod + ", " + days[i]
      end

      # Inner while loop is to string consecutive days together if the current day is selected
      if deal_days[i]
        j = i + 1
        while j<7
          # If the day is not selected, break out of loop
          if !deal_days[j]
            break
          elsif j == 6 && deal_days[j]
            dealperiod = dealperiod + "-" + days[j]
            i = j+1
            break
          elsif j == 6 && !deal_days[j]
            i = j+1
            break
            # If the day is selected, and next one is selected, just continue
          elsif deal_days[j] && deal_days[j+1]
            j = j+1
            # If day is selected, and next one is not, place "- day" and break
          elsif deal_days[j] && !deal_days[j+1]
            dealperiod = dealperiod + "-" + days[j]
            i = j + 1
            break
          end
        end
      end
      i = i +1
    end
    dealperiod
  end
  helper_method :format_days

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

