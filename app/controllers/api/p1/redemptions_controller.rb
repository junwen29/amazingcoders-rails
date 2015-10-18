class Api::P1::RedemptionsController < Api::P1::ApplicationController

  def create
    user_id = params[:user_id]
    deal_id = params[:deal_id]
    venue_id = params[:venue_id]

    redemption = Redemption.save (user_id, deal_id, venue_id)
    # redemption.user_id = user_id
    # redemption.deal_id = deal_id
    # redemption.venue_id = venue_id
    # redemption.save

    render_jbuilder do |json|
      redemption.to_json json
    end

  end
end