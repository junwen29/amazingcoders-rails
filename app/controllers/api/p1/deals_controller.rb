class P1::DealsController < P1::ApplicationController

  def index
    deals = DealService.get_active_deals
    render_jbuilders(deals) do |json,deal|
      deal.to_json
    end
  end

end