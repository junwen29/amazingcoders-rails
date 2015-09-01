class Biz::VenuesController < Biz::ApplicationController
    
	def get
		@venue = MerchantService.get_venue(m_id, params[:venue_id])
	end
  	
  def edit
    @venue_type = "venue"
    @venues, @temp_venues = MerchantService.get_all_venues(m_id)

    venue_id = params[:id]
    @venue = MerchantService.get_venue(m_id, venue_id)

    @editSelected = "selected"

    # set last viewed cookie
    cookies.permanent[:lvVenue] = [m_id, "v", @venue.id]

    # build venue image
    #@venue_image = @venue.venue_images.build

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

    @select_day_hours_string = @select_days_hours.to_json

    # venue dishes curated
    #@curated_dishes_count = @venue.dishes.curated.count

    ## venue promotions
    @venue_promotion = MerchantService.get_single_venue_promotion(venue_id)
    @venue_promotion = VenuePromotion.new unless @venue_promotion
  end

  # def menu
  #   @venue_type = "venue"
  #   @venues, @temp_venues = MerchantService.get_all_venues(m_id)

  #   venue_id = params[:id]
  #   @venue = MerchantService.get_venue(m_id, venue_id)

  #   @menuSelected = "selected"
  # end

  # def reservations
  #   @venue_type = "venue"
  #   @venues, @temp_venues = MerchantService.get_all_venues(m_id)

  #   venue_id = params[:id]
  #   @venue = MerchantService.get_venue(m_id, venue_id)

  #   @reservationsSelected = "selected"
  #   @merchant_email = current_merchant.email
  # end

  def premium_listing
    @venue_type = "venue"
    @venues, @temp_venues = MerchantService.get_all_venues(m_id)

    venue_id = params[:id]
    @venue = MerchantService.get_venue(m_id, venue_id)

    @promotionsSelected = "selected"
    @merchant_email = current_merchant.email
  end
  
  def list_a_deal
    @venue_type = "venue"
    @venues, @temp_venues = MerchantService.get_all_venues(m_id)

    venue_id = params[:id]
    @venue = MerchantService.get_venue(m_id, venue_id)
    @venue_promotion = @venue.venue_promotions.first

    @dealSelected = "selected"
    @merchant_email = current_merchant.email
  
  end

  def activity
    @venue_type = "venue"
    @venues, @temp_venues = MerchantService.get_all_venues(m_id)
    @statsSelected = "selected"
    
    venue_id = params[:id]
    @venue = MerchantService.get_venue(m_id, venue_id)

    # hardcode - check if m_id is dix or alvin
    unless [12, 277].include?(m_id)
     redirect_to biz_dashboard_edit_venue_path(@venue.id)
    end

    period = 7
    yesterday = DateTime.now - 1.day
    
    # get ga_client
    ga_client = get_google_client
    
    # current period
    end_date = yesterday
    start_date = end_date - (period - 1).days

    @start_date = start_date.strftime("%d/%m/%Y")
    @end_date = end_date.strftime("%d/%m/%Y")

    # get total and daily page views for current period
    @current_page_views_result = get_page_views_result(venue: @venue, ga_client: ga_client, start_date: start_date, end_date: end_date, ga_daily_views: true)

    # get total wishlist for current period
    @current_wishlist_total = @venue.wishes.count

    # get trending position for current period
    city = City.where(name: @venue.city).first
    trending_venues = VenueService.trending(2.weeks, city: city,
                                            limit:50, offset:0,
                                            load_venues: false)
    position = trending_venues.map{ |r| r.id.to_i }.index(@venue.id)
    @current_trending_position = position.nil? ? ">50" : position + 1

    # previous period
    end_date = start_date - 1.day
    start_date = end_date - (period - 1).days

    # get total page views for previous period
    previous_page_views_result = get_page_views_result(venue: @venue, ga_client: ga_client, start_date: start_date, end_date: end_date)

    # get total wishlist for previous period
    previous_wishlist_total = Wish.where(:venue_id => venue_id, :created_at => (start_date.midnight)..(end_date.midnight + 1.day)).count
    previous_wishlist_total = @venue.wishes.where("created_at < ?", end_date.midnight + 1.day).count

    # calculate difference of page views and wishlists
    # calculate current page views vs previous page views
   @change_page_views = compare_with_previous_period(current_period: @current_page_views_result["web_page_views_total"], 
                                                      previous_period: previous_page_views_result["web_page_views_total"])

    # calculate current wishlists and previous wishlists
    @change_wishlist = compare_with_previous_period(current_period: @current_wishlist_total, previous_period: previous_wishlist_total)
  end


	def update
		@venue = MerchantService.update_venue(m_id, params)

    if @venue.errors.empty?
      flash[:success] = "Your changes has been saved. It will take a while for the change to be effected." 
    end

    if (params[:page].blank?)
      redirect_to biz_dashboard_edit_venue_path(@venue)
    elsif (params[:page] == 'menu')
      redirect_to biz_dashboard_menu_venue_path(@venue)
    elsif (params[:page] == 'promotions')
      redirect_to biz_dashboard_promotions_venue_path(@venue)
    else
      redirect_to biz_dashboard_edit_venue_path(@venue)
    end
	end

  private
    def get_google_client

      # if @google_client.nil?

        require 'google/api_client'
     
        api_version = 'v3'
        cached_api_file = "analytics-#{api_version}.cache"

        # Email of service account
        service_account_email = '443814783661-6hunve7s7mmo2lf15e9smgt1m9f8v8q3@developer.gserviceaccount.com'
        # File containing your private key
        if Rails.env.development?
          key_file = Rails.root.join('config', 'burpple-analytics-app-google-service-account-privatekey.p12').to_s
        else
          s3 = AWS::S3.new
          o  = s3.buckets['burpple-secure'].objects['burpple-analytics-app-google-service-account-privatekey.p12']
          key_file = 'tmp/google-key.p12'
          File.open(key_file, 'wb'){ |file| file.write o.read }
        end
        key_secret = 'notasecret' # Password to unlock private key

        client = Google::APIClient.new(
          :application_name => 'Burpple Analytics App',
          :application_version => '1.0.0')

        # Load our credentials for the service account
        key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
        client.authorization = Signet::OAuth2::Client.new(
          :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          :audience => 'https://accounts.google.com/o/oauth2/token',
          :scope => 'https://www.googleapis.com/auth/analytics.readonly',
          :issuer => service_account_email,
          :signing_key => key)

        # Request a token for our service account
        client.authorization.fetch_access_token!

        @@analytics = nil
        # Load cached discovered API, if it exists. This prevents retrieving the
        # discovery document on every run, saving a round-trip to the discovery service.
        if File.exists? cached_api_file
          File.open(cached_api_file) do |file|
            @@analytics = Marshal.load(file)
          end
        else
          @@analytics = client.discovered_api('analytics', api_version)
          File.open(cached_api_file, 'w') do |file|
            Marshal.dump(@@analytics, file)
          end
        end

        @google_client = client
        
      # end

      return @google_client

    end

    def get_page_views_result(venue:, ga_client:, start_date:, end_date:, ga_daily_views: false)

      gaPagePath = "ga:pagePath==/" << venue.url_key
      dimensions = ga_daily_views ? "ga:pagePath, ga:date" : "ga:pagePath"

      base_params = {
        'start-date' => start_date.strftime("%Y-%m-%d"),
        'end-date' => end_date.strftime("%Y-%m-%d"),
        'metrics' => "ga:pageviews",
        'dimensions' => dimensions,
        'filters' => gaPagePath
      }

      web_profileID = '71565603' # Analytics profile ID.
      parameters    = base_params.merge({'ids' => "ga:" + web_profileID})
      web_page_views_raw = ga_client.execute(:api_method => @@analytics.data.ga.get, :parameters => parameters)

      results = Hash.new
      results["web_page_views_total"] = web_page_views_raw.data.totals_for_all_results["ga:pageviews"].to_i

      ### get mobile pageviews from our own tracking
      #   eventually we can use this for web views as well, but we only started
      #   tracking so not enough data for now.
      r = VenuePageview.search query: { 
                                 filtered: {
                                   query: { match_all: {} },
                                   filter: {
                                     bool: {
                                       must: [
                                         { range:
                                           { created_at: { gte: "now-1w/d" } }
                                         },
                                         { term: { venue_id: venue.id } }
                                       ]
                                     } 
                                   }
                                 } 
                               },
                               aggs: {
                                 view_counts: {
                                   date_histogram: {
                                     field: :created_at,
                                     interval: :day,
                                     min_doc_count: 0,
                                     extended_bounds: {
                                       min: "now-1w",
                                       max: "now"
                                     }
                                   }
                                 }
                               }, size: 0

      results["web_page_views_total"] += r.total

      if ga_daily_views
        web_page_views_daily = {}

        buckets = r.response.aggregations.view_counts.buckets

        buckets.each do |b|
          web_page_views_daily[Time.at(b[:key]/1000).to_date] = b.doc_count
        end

        web_page_views_raw.data.rows.each do |day| 
          date = day[1].to_date
          web_page_views_daily[date] ||= 0
          web_page_views_daily[date] += day[2].to_i
        end


        results["web_page_views_daily"] = web_page_views_daily.to_a
      end

      results
    end

    def compare_with_previous_period(current_period:, previous_period:)
      difference = current_period - previous_period

      if difference < 0
        change = ["statsBody-summary-stat-text-body-change--negative", -difference]
      elsif difference > 0
        change = ["statsBody-summary-stat-text-body-change--positive", difference]
      else
        change = ["", difference]
      end

      change
    end

end
