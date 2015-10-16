class Api::P1::DealsController < Api::P1::ApplicationController

  def index
    # get deals according to params {active, freebies, discount, popular}

    # params[:popular] = request.params[:popular]
    # params[:type]  = request.params[:type]

    user_id = get_current_user_id

    case params[:type]
      when 'popular'
        deals = DealService.get_popular_deals

      when 'discount'
        deals = DealService.get_active_deals_by_type('Discount')

      when 'freebies'
        deals = DealService.get_active_deals_by_type('Freebies')

      when 'bookmark'
        deals = DealService.get_bookmark_deals(user_id)

      else
        deals = DealService.get_active_deals
    end

    deals = BookmarkService.set_is_bookmarked(deals,user_id) if user_id
    render_jbuilders(deals) do |json,deal|
      deal.to_json json
    end
  end

  def get_deal
    user_id = get_current_user_id
    deal = DealService.get(params[:id], user_id)
    render_jbuilder do |json|
      deal.to_json json
    end
  end

end