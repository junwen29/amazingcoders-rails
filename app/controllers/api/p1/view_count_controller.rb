
class Api::P1::ViewCountController <  Api::P1::ApplicationController

  def create_deal_view_count
    entry = params[:entry]
    deal_id = params[:deal_id]
    user_id = get_current_user_id

    #  update deal_analytic object first!
    DealAnalyticService.update_unique_view_count user_id, deal_id
    DealAnalyticService.add_view_count deal_id

    Viewcount.create!(deal_id: deal_id, user_id: user_id, entry: entry)

    head_ok
  end
end