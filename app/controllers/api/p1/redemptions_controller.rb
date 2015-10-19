class Api::P1::RedemptionsController < Api::P1::ApplicationController

  def create
    user_id = params[:user_id]
    deal_id = params[:deal_id]
    venue_id = params[:venue_id]

    redemption = RedemptionService.createRedemption deal_id, user_id, venue_id
    # redemption.user_id = user_id
    # redemption.deal_id = deal_id
    # redemption.venue_id = venue_id
    # redemption.save

    if redemption.blank?
      render_error_json(RedeemError.new )
    else
      render_jbuilder do |json|
        redemption.to_json json
      end
    end
  end

  def index
    user_id = params[:user_id]
    redemptions = RedemptionService.getRedemptionsByUserId user_id
    if redemptions.empty?
      render_error_json(NotFoundError.new)
    else
      render_jbuilders(redemptions) do |json,redemption|
        redemption.to_json json
      end
    end

  end

end