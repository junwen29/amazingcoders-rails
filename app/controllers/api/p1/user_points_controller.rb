class Api::P1::UserPointsController < Api::P1::ApplicationController

  def index
    gifts = Gift.where(:gift_type => 'User')
    render_jbuilders(gifts) do |json, gift|
      gift.to_json json
    end
  end

  def create
    gift = Gift.find_by_id params[:id]
    user = User.find_by_authentication_token params[:auth_token]
    user_id = user.id
    points = gift.points
    reason = gift.name
    operation = 'Debit'
    UserPointService.new_point(reason, points, operation, user_id)
    GiftMailer.user_gift_email(user, gift).deliver
    head :ok
  end

  def get_user_points
    user = User.find_by_id params[:id]
    user_points = user.user_points
    render_jbuilders(user_points) do |json, user_point|
      user_point.to_json(json)
    end
  end

end