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
    # all_deal_venue = DealVenue.where(:venue_id => params[:id])#.select(:deal_id)
    # # deals = []
    # deals = Array
    # all_deal_venue.each do |d|
    #   deal=Deal.find(d.deal_id)
    #   deals << deal
    # end
    venue = Venue.find(params[:id])
    deals = venue.deals

    #active_deals = []
    #deals.each do
    #  active_deal = Deal.where('expiry_date >= ? AND (start_date = ? OR expiry_date = ? OR (start_date < ? AND expiry_date > ?) OR (expiry_date > ? AND active = true))', DateTime.now, DateTime.now, DateTime.now, DateTime.now, DateTime.now, DateTime.now)
    #  active_deals << active_deal
    #end
    render_jbuilders(deals) do |json, deal|
      deal.to_json json
    end
  end

end