class Biz::DashboardController < Biz::ApplicationController
  before_filter :authenticate_merchant!, except: [:help] 
  
  def index
    @merchant = current_merchant

    venues, temp_venues = MerchantService.get_all_venues(@merchant.id)

    if (venues.blank? && temp_venues.blank?)
    # merchant has no venues
      # create
      redirect_to biz_dashboard_getting_started_path
    else
    # merchant has venues
      
      lastViewed = cookies[:lvVenue] || ""
      
      if !lastViewed.blank?
      # cookie exists
        lastViewed = lastViewed.split("&")

        lastViewed_m_id = lastViewed[0]
        lastViewed_type = lastViewed[1]
        lastViewed_id = lastViewed[2]

        if lastViewed_m_id == m_id.to_s
        # cookie belongs to current merchant
          case lastViewed_type
            when "tv"
              temp_venue = MerchantService.get_temp_venue(m_id, lastViewed_id)

              if temp_venue
                redirect_to biz_dashboard_edit_temp_venue_path(lastViewed_id)
              else
                default_redirect(temp_venues, venues)
              end
            when "v"
              venue = MerchantService.get_venue(m_id, lastViewed_id)

              if venue
                redirect_to biz_dashboard_activity_venue_path(lastViewed_id)
              else
                default_redirect(temp_venues, venues)
              end
            else
              default_redirect(temp_venues, venues)
          end
        else
          default_redirect(temp_venues, venues)
        end
      else
        default_redirect(temp_venues, venues) 
      end
    end
  end

  def getting_started
    venues, temp_venues = MerchantService.get_all_venues(m_id)

    if (venues.blank? && temp_venues.blank?)
      @select_day_hours_string = "[]".html_safe
      @venue = TempVenue.new
      @venue_type = "temp_venue"
      @venue.build_venue_image if @venue.venue_image.nil?
    else
      redirect_to biz_dashboard_path
    end
  end

  def help
    url = "https://burpple.desk.com/?b_id=1299"
    redirect_to(url)
  end

  def ad_interest
    venue_type = params[:type]
    venue_id = params[:id]

    if venue_type
      venue = (venue_type == "venue" ? MerchantService.get_venue(m_id, venue_id) : MerchantService.get_temp_venue(m_id, venue_id))

      if venue
        MerchantMailer.ad_interest_email(venue, venue_type).deliver
        flash[:success] = "Thank you for indicating your interest, our team will be in touch with you soon."
        (venue_type == "venue") ? redirect_to(biz_dashboard_promotions_venue_path(venue.id)) : (redirect_to biz_dashboard_promotions_temp_venue_path(venue.id))
      else
        flash[:error] = "Something went wrong, please try again."
        redirect_to biz_dashboard_path
      end
    end

  end

  private
    
    def default_redirect(temp_venues, venues)
      if !venues.blank?
        redirect_to biz_dashboard_activity_venue_path(venues[0].id)
      else
        redirect_to biz_dashboard_edit_temp_venue_path(temp_venues[0].id)
      end
    end

end
