class Biz::VenuePromotionsController < Biz::ApplicationController

  def index
  	# get data required for dashboard
  	@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required

    # check if dix
    check_if_dix(@venue)

  	# get all venue_promotions for venue
    @venue_promotions = @venue.venue_promotions.order("created_at DESC")
  end
  
  def list_a_deal
    venue_id = params[:id]
    params_venue_promotion = params[:venue_promotion]
  
    if params_venue_promotion[:description].blank?
    MerchantService.delete_single_venue_promotion(venue_id)
    flash[:info] = "Your deal has been removed!"
    else
    MerchantService.update_single_venue_promotion(venue_id, params_venue_promotion)
    flash[:success] = "Your deal has been listed!"
    end

    # redirect to venue_promotion adding 
    redirect_to biz_dashboard_list_a_deal_venue_path(venue_id)
  end

  def new
  	# get data required for dashboard
  	@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required

    # check if dix
    check_if_dix(@venue)

  	# create new VenuePromotion
  	@venue_promotion = VenuePromotion.new
  end

  def edit
  	# get data required for dashboard
  	@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required

    # check if dix
    check_if_dix(@venue)

  	# get params and venue_promotion
  	venue_promotion_id = params[:id]
  	@venue_promotion = get_venue_promotion(venue_promotion_id, @venue.id)

    venue_promotion_status = get_venue_promotion_status(@venue_promotion)

    if venue_promotion_status == "live"
      flash[:error] = "Live promotion cannot be edited."
      # redirect to index
      redirect_to biz_dashboard_venue_promotions_path(@venue.id)
    elsif venue_promotion_status == "expired"
      flash[:error] = "Expired promotion cannot be edited."
      # redirect to index
      redirect_to biz_dashboard_venue_promotions_path(@venue.id)
    end
  end

  def show
  	# get data required for dashboard
  	@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required

    # check if dix
    check_if_dix(@venue)

    venue_promotion_id = params[:id]
    @venue_promotion = get_venue_promotion(venue_promotion_id, @venue.id)
    @venue_promotion_status = get_venue_promotion_status(@venue_promotion)
  end

  def create
  	@venue = get_venue
    venue_promotion = @venue.venue_promotions.new(add_permit(params[:venue_promotion]))

    # save
  	if venue_promotion.save
  		flash[:success] = "Your promotion has been created."

  		# redirect to index
  		redirect_to biz_dashboard_venue_promotions_path(@venue.id)
  	else
  		error_messages = venue_promotion.errors.messages.each.map do |field, msg|
  			field.to_s.humanize + " " + msg.join(', ')
  		end
  		flash[:error] = error_messages

      p error_messages
  		# redirect to create
  		redirect_to new_biz_dashboard_venue_promotion_path
    end
  end

  def update
  	@venue = get_venue

    venue_promotion_id = params[:id]
  	venue_promotion = get_venue_promotion(venue_promotion_id, @venue.id)

  	# update
    if venue_promotion.update_attributes(add_permit(params[:venue_promotion]))
        flash[:success] = "Your promotion has been updated."

        # redirect to index
      redirect_to biz_dashboard_venue_promotions_path(@venue.id)
    else
        error_messages = venue_promotion.errors.messages.each.map do |field, msg|
        field.to_s.humanize + " " + msg.join(', ')
      end
      flash[:error] = error_messages
      # redirect to create
      redirect_to edit_biz_dashboard_venue_promotion_path(@venue.id, venue_promotion_id)
    end

  end

  def destroy
    @venue = get_venue

    venue_promotion_id = params[:id]
  	venue_promotion = get_venue_promotion(venue_promotion_id, @venue.id)

  	# destroy
  	if venue_promotion.destroy
      flash[:success] = "Your promotion has been deleted."
    else
      error_messages = venue_promotion.errors.messages.each.map do |field, msg|
        field.to_s.humanize + " " + msg.join(', ')
      end
      flash[:error] = error_messages
    end

  	# redirect to index
	 redirect_to biz_dashboard_venue_promotions_path(@venue.id)
  end

  private
    def add_permit(promotion_params)
      promotion_params.permit(:promotion_type, :description, :claim_instruction, :supporting_website, :started_at, :ended_at, :enabled, :submitted)
    end

  	def get_all_dashboard_required
	  	@venue_type = "venue"
	  	@dealSelected = "selected"

	  	@venues, @temp_venues = MerchantService.get_all_venues(m_id)
	    venue_id = params[:venue_id]
	    @venue = MerchantService.get_venue(m_id, venue_id)

	    [@venue_type, @promotionsSelected, @venues, @temp_venues, @venue]
  	end

    def get_venue
      venue_id = params[:venue_id]
      venue = MerchantService.get_venue(m_id, venue_id)
      unless venue
        raise ActiveRecord::RecordNotFound
      end
      venue
    end

  	def get_venue_promotion(venue_promotion_id, venue_id)
  		VenuePromotion.where(:id => venue_promotion_id, :venue_id => venue_id).first
  	end

    def get_venue_promotion_status(venue_promotion)
      status = ""
      enabled = venue_promotion.enabled
      submitted = venue_promotion.submitted

      if submitted
        if enabled
          if Date.today < venue_promotion.started_at
            status = "scheduled"
          elsif Date.today <= venue_promotion.ended_at
            status = "live"          
          else
            status = "expired"
          end
        end
      end

      status
    end

    # temp exclusive access to dixon (m_id: 12)
    def check_if_dix(venue)
      if m_id != 12
        redirect_to biz_dashboard_promotions_venue_path(venue.id)
      end
    end

end
