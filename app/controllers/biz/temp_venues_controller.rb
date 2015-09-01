class Biz::TempVenuesController < Biz::ApplicationController

  def new
    @select_day_hours_string = "[]".html_safe
    @venue = TempVenue.new
    @venue_type = "temp_venue"
    @venue.build_venue_image if @venue.venue_image.nil?
  end

  def create
    @venue = MerchantService.update_temp_venue(m_id, params)
    biz_track_event(nil, {distinct_id: @venue.merchant_id}, true) if params[:merchant] and @venue
    redirect_to biz_dashboard_edit_temp_venue_path(@venue)
  end
  
  def edit
    @page_name = "Profile"
    @venue_type = "temp_venue"
  	@venues, @temp_venues = MerchantService.get_all_venues(m_id)

  	venue_id = params[:id]
  	@venue = MerchantService.get_temp_venue(m_id, venue_id)

    @venue.build_venue_image if @venue.venue_image.nil?
    @venue.merchant ||= current_merchant

    @editSelected = "selected"

    # set last viewed cookie
    cookies.permanent[:lvVenue] = [m_id, "tv", @venue.id]

    # get venue hours

    @venue_hours = @venue.venue_hours.group_by(&:day).to_a

    # convert into [[["Wed", "friday"], 0, 0], [["wed", "friday"], 0, 0 ]]
    @select_days_hours = []

    @venue_hours.each do |vh|
      vh[1].each do |h|

        match = false
        
        @select_days_hours.each do |t|
          match = false

          if t[1] == h.started_at and t[2] == h.ended_at
            match = true
          end

          if (match)
            t[0] << vh[0]
            break  
          end
        end

        if (!match)
            match = false
            array_item = [[vh[0]], h.started_at, h.ended_at]
            @select_days_hours << array_item
        end
      end
    end

    # convert into string
    @select_day_hours_string = ""
    @select_day_hours_string << "["
    @select_days_hours.each_with_index do |dvh, i|
      @select_day_hours_string << "["
      dvh.each_with_index do |vh, x|
        if x == 0
          @select_day_hours_string << "["
          @select_day_hours_string << vh.map { |y| '"' + y + '"' }.join(",")
          @select_day_hours_string << "]"
        else
          @select_day_hours_string << ","
          #@select_day_hours_string << '"' + Time.at(vh).utc.strftime("%I:%M %p") + '"'
          @select_day_hours_string << vh.to_s
        end
      end
      @select_day_hours_string << "]"

      unless i == @select_days_hours.count - 1
        @select_day_hours_string << ","
      end
    end
    @select_day_hours_string << "]"

    @select_day_hours_string = @select_day_hours_string.html_safe


    # get temp venue progress
    @progress = MerchantService.temp_venue_progress(@venue)
    @steps_remaining = 0
    if @progress[false]
      @steps_remaining = @progress[false].count
    end

  end

  # def menu
  #   @page_name = "Menu"
  #   @venue_type = "temp_venue"
  #   @venues, @temp_venues = MerchantService.get_all_venues(m_id)

  #   venue_id = params[:id]
  #   @venue = MerchantService.get_temp_venue(m_id, venue_id)

  #   @menuSelected = "selected"
  # end

  def premium_listing
    @page_name = "Promotions"
    @venue_type = "temp_venue"
    @venues, @temp_venues = MerchantService.get_all_venues(m_id)

    venue_id = params[:id]
    @venue = MerchantService.get_temp_venue(m_id, venue_id)

    @promotionsSelected = "selected"
  end

  # def reservations
  #   @page_name = "Reservations"
  #   @venue_type = "temp_venue"
  #   @venues, @temp_venues = MerchantService.get_all_venues(m_id)

  #   venue_id = params[:id]
  #   @venue = MerchantService.get_temp_venue(m_id, venue_id)

  #   @reservationsSelected = "selected"
  #   @merchant_email = current_merchant.email
  # end
  def verify
    @venue = MerchantService.update_temp_venue(m_id, params)

    if @venue.previous_changes.include?(:submitted) and @venue.submitted
      flash[:info] = "Thank you for claiming your listing. Our team will be in touch with you shortly."
    end
    redirect_to biz_dashboard_edit_temp_venue_path(@venue)
    
  end


  def update
    @venue = MerchantService.update_temp_venue(m_id, params)

    if @venue.previous_changes.include?(:submitted) and @venue.submitted
      flash[:info] = "Thank you for claiming your listing. Our team will be in touch with you shortly."
    end

    unless !params[:page].blank?
      if @venue.errors.empty?
        flash[:success] = "Your changes has been updated successfully." 
      end
    end

    if (params[:page].blank?)
      redirect_to biz_dashboard_edit_temp_venue_path(@venue)
    elsif (params[:page] == 'menu')
      redirect_to biz_dashboard_menu_temp_venue_path(@venue)
    elsif (params[:page] == 'promotions')
      redirect_to biz_dashboard_promotions_temp_venue_path(@venue)
    elsif (params[:page] == 'reservations')
      redirect_to biz_dashboard_reservations_temp_venue_path(@venue)
    else
      redirect_to biz_dashboard_edit_temp_venue_path(@venue)
    end
    
  end

  def destroy
    venue = MerchantService.delete_temp_venue(m_id, params[:id])

    if venue #unsuccessful
      error_messages = venue.errors.messages.each.map do |field, msg|
        field.to_s.humanize + " " + msg.join(', ')
      end
      flash[:error] = error_messages
      redirect_to biz_dashboard_edit_temp_venue_path(venue)
    else
      flash[:success] = "Your restaurant has been deleted."
      redirect_to biz_dashboard_path
    end
  end

end

