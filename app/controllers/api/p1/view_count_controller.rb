
class Api::P1::ViewCountController <  Api::P1::ApplicationController

  def create_deal_view_count
    entry = params[:entry]
    deal_id = params[:deal_id]
    user_id = get_current_user_id
    Viewcount.create!(deal_id: deal_id, user_id: user_id, entry: entry)

    #  update deal_analytic object
    DealAnalyticService.set_view_count deal_id
    DealAnalyticService.set_unique_view_count deal_id

    head_ok
  end
end