
class Api::P1::AnalyticsController < Api::P1::ApplicationController

  def register_query
    query = params[:query]
    type = params[:type]

    user_query = UserQuery.save(query,type)
    if user_query.persisted?
      head_ok
      return
    end
    render_error_response(:bad_request)
  end

  def register_deal_view_count
    entry = params[:entry]
    deal_id = params[:deal_id]
    user_id = get_current_user_id

    #  update deal_analytic object first!
    DealAnalyticService.update_unique_view_count user_id, deal_id
    DealAnalyticService.add_view_count deal_id

    Viewcount.create!(deal_id: deal_id, user_id: user_id, entry: entry)

    head_ok
  end

  def register_redemption
    deal_id = params[:deal_id]
    DealAnalyticService.set_redemption_count deal_id
    head_ok
  end
end