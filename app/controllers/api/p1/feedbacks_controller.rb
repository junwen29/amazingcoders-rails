
class Api::P1::FeedbacksController < Api::P1::ApplicationController

  def create
    user_id = params[:user_id]
    title = params[:title]
    category = params[:category]
    desc = params[:desc]

    feedback = UserFeedback.create(:title => title, :category => category, :content => desc, :user_id => user_id)

    if feedback.persisted?
      head_ok
      return
    end
    render_error_response(:bad_request)

  end
end