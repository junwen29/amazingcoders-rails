
class Api::P1::VenuesController < Api::P1::ApplicationController

  def index
    venues = Venue.all
    render_jbuilders(venues) do |json,venue|
      venue.to_json json
    end
  end

  def show
    venue_to_show = Venue.find(params[:id])
    render_jbuilder do |json|
      venue_to_show.show_json_object json
    end
  end

end
