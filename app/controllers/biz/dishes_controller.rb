class Biz::DishesController < Biz::ApplicationController

	def index
		@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required

		@page = params[:page] || 1
		per_page = 20
		# @start_index = (@page.to_i - 1) * per_page + 1

  	@dishes = @venue.dishes.paginate(:page => @page, :per_page => per_page)
  	@chef_recommendation_count = @venue.dishes.where(:curated => true).count
	end

	def new
		@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required

		#check chef_recommendation_count
		chef_recommendation_count = @venue.dishes.where(:curated => true).count

		if chef_recommendation_count >= 10
			# redirect to index
		  	redirect_to biz_dashboard_dishes_path(@venue.id)
		end

		@dish = @venue.dishes.new
	end

	def edit
		@venue_type, @promotionsSelected, @venues, @temp_venues, @venue = get_all_dashboard_required
		@dish = get_dish(@venue)
	end

	def create
		venue = get_venue

		# derank previous chef recommendations
		chef_recommendations = venue.dishes.where(:curated => true).where("rank > 0")
		new_rank = 98
		chef_recommendations.each do |cr|
			cr.rank = new_rank
			cr.save
			new_rank -= 1
		end

		dish = venue.dishes.new(add_permit(params[:dish]))
		dish.rank = 99

		if dish.image_url.blank?
			flash[:error] = ["A photo is required for your dish."]

			# redirect to create
	 		redirect_to new_biz_dashboard_dish_path
	  else
		  # save
		 	if dish.save
        biz_track_event("Submitted chef recommendation", {
          'web.submitted_chef_recommendation.number_of_chef_recommendations_added' => 1,
          'number_of_chef_recommendations_added' => 1,
        })
	  		clear_dishes_cache(venue)
	  		flash[:success] = "Your chef recommendation has been added. It might take a while for the changes to be reflected."

	  		# redirect to index
	  		redirect_to biz_dashboard_dishes_path(venue.id)
		  else
	  		error_messages = dish.errors.messages.each.map do |field, msg|
	  			field.to_s.humanize + " " + msg.join(', ')
	  		end
	  		flash[:error] = error_messages

	  		# redirect to create
	  		redirect_to new_biz_dashboard_dish_path
		  end
		end
	end

	def update
		venue = get_venue
		dish = get_dish(venue)

		if dish.image_url.blank?
			flash[:error] = ["A photo is required for your dish."]

     		# redirect to create
    		redirect_to new_biz_dashboard_dish_path
	    else
	    	      # update
      		if dish.update_attributes(add_permit(params[:dish]))
        		biz_track_event("Updated dish", {
        		  'web.updated_dish.number_of_dishes_updated' => 1,
	    	      'number_of_dishes_updated' => 1,
	    	    })
    		    clear_dishes_cache(venue)
        		flash[:success] = "Your chef recommendation has been updated. It might take a while for the changes to be reflected."
        		# redirect to index
        		redirect_to biz_dashboard_dishes_path(venue.id)
	    	else
	        	error_messages = dish.errors.messages.each.map do |field, msg|
         			field.to_s.humanize + " " + msg.join(', ')
	        	end

	        	flash[:error] = error_messages
        		# redirect to create
		        redirect_to edit_biz_dashboard_dish_path(venue.id, dish.id)
	    	end
		end
	end

	def destroy
		# get params and venue_promotion
	  	venue = get_venue
	  	dish = get_dish(venue)
	  	unless !dish.curated
		  	# destroy
		  	if dish.destroy
		  	  clear_dishes_cache(venue)
		      flash[:success] = "Your chef recommendation has been deleted. It might take a while for the changes to be reflected."
		    else
		      error_messages = dish.errors.messages.each.map do |field, msg|
		        field.to_s.humanize + " " + msg.join(', ')
		      end
		      flash[:error] = error_messages
		    end
		end

	  	# redirect to index
		 redirect_to biz_dashboard_dishes_path(venue.id)
	end

	private
		def add_permit(dish_params)
			dish_params.permit(:venue_id, :name, :price, :bio, :curated, :rank, :image)
		end

		def get_all_dashboard_required
		  	@venue_type = "venue"
		  	@menuSelected = "selected"

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

  		def get_dish(venue)
  			dish_id = params[:id]
  			dish = venue.dishes.where(:id => dish_id).first
  			unless dish
  				raise ActiveRecord::RecordNotFound
  			end
  			dish
  		end

  		def clear_dishes_cache(venue)
  			offset = 0 
  			limit = 6
			loop do
				Rails.cache.delete([Venue.name,venue.id,Dish.name,offset,limit])
				offset += limit
				break if offset > venue.dishes.count
			end
  		end
end
