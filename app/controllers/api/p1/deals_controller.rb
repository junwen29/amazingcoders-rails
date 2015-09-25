class Api::P1::DealsController < Api::P1::ApplicationController

  def index
    # get deals according to params {active, freebies, discount, popular}

    # params[:popular] = request.params[:popular]
    # params[:type]  = request.params[:type]

    case params[:type]
      when 'popular'
      deals = DealService.get_popular_deals

      when 'discount'
      deals = DealService.get_active_deals_by_type('discount')

      when 'freebies'
        deals = DealService.get_active_deals_by_type('freebie')

      else
        deals = DealService.get_active_deals
    end

    render_jbuilders(deals) do |json,deal|
      deal.to_json json
    end
  end

  def get_deal
    deal = Deal.find(params[:id])
    render_jbuilder do |json|
      deal.to_json json
    end
  end


end