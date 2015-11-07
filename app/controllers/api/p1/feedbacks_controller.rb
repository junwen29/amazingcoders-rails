
class Api::P1::FeedbacksController < Api::P1::ApplicationController

  def create
    user_id = params[:user_id]
    title = params[:title]
    title.tr("%20", " ")
    category = params[:category]
    desc = params[:desc]
    desc.tr("%20", " ")

    feedback = UserFeedback.create(:title => title, :category => category, :content => desc, :user_id => user_id)
    FeedbackMailer.user_feedback_email(User.find_by_id(user_id), feedback).deliver
    if feedback.persisted?
      head_ok
      return
    end
    render_error_response(:bad_request)

  end

  def get_feedbacks
    user = User.find_by_id params[:id]
    user_feedbacks = user.user_feedbacks
    render_jbuilders(user_feedbacks) do |json, user_feedback|
      user_feedback.to_json(json)
    end
  end

end