
class Api::P1::VenuesController < Api::P1::ApplicationController

  def index
    venues = Venue.all
    render_jbuilders(venues) do |json,venue|
      venue.to_json json
    end
  end
end
