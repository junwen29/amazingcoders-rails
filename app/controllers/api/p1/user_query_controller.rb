
class Api::P1::UserQueryController < Api::P1::ApplicationController

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

end