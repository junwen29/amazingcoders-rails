class Api::P1::NotificationsController < Api::P1::ApplicationController

  def index_by_user
    user_id = params[:user_id]

    #limit notifications to recent 10
    notifications = Notification.where(:user_id => user_id).order('created_at DESC')
    render_jbuilders(notifications) do |json,notification|
      notification.to_json json
    end
  end

end