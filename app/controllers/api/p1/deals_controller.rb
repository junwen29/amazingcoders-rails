class Api::P1::DealsController < Api::P1::ApplicationController

  def index
    # TODO change to active deals only
    deals = Deal.all
    render_jbuilders(deals) do |json,deal|
      # json.(deal, :id, :title)
      deal.to_json json
    end
  end

  def get_deal
    deal = Deal.find(params[:id])
    render_jbuilder do |json|
      deal.to_json json
    end
  end

  def get_deals_for_venue
    venue = Venue.find(params[:id])
    deals = venue.deals
    render_jbuilders(deals) do |json, deal|
      deal.to_json json
    end
  end

end