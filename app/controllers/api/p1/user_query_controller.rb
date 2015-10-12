
class Api::P1::UserQueryController < Api::P1::ApplicationController

  def register_query
    query = params[:query]
    type = params[:type]

    auth_token = params[:auth_token]
    user = User.find_by_authentication_token auth_token

    user_query = UserQuery.save(user,query,type)
    if user_query.persisted?
      head_ok
      return
    end
    render_error_response(:bad_request)
  end

end