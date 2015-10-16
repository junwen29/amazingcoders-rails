class Api::P1::VenuesController < Api::P1::ApplicationController

  def index

    venues = Venue.all
    user_id = get_current_user_id
    venues = WishService.set_is_wishlist(venues,user_id) if user_id
    render_jbuilders(venues) do |json,venue|
      venue.to_json json
    end
  end

  def get_venue
    user_id = get_current_user_id
    venue_to_show = VenueService.get(params[:id], user_id)
    render_jbuilder do |json|
      venue_to_show.to_full_json json
    end
  end

end
