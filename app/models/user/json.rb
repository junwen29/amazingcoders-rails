module User::Json
  extend ActiveSupport::Concern

  included do
    def to_auth_json(json, options = {})
      to_account_json(json, options = {})
      json.auth_token       authentication_token
      json.total_points     total_points
    end

    # for account api
    def to_account_json(json, options = {})
      to_json(json, options)
      json.email email
      # json.birthday birthday ? birthday.strftime("%Y-%m-%d") : nil
      # json.phone    phone

    end

    def to_json(json, options = {})
      self.to_show_owner(json, options)

      user_points_to_json(json)
    end

    def to_show_owner(json, options = {})
      json.id id
      json.first_name first_name
      json.last_name last_name
      json.username   username
      json.email email
      json.total_points total_points
      json.updated_at updated_at
      json.created_at created_at
      json.num_wishes UserService.get_num_wishes(id)
      json.num_bookmarks UserService.get_num_bookmarks(id)
    end

    def user_points_to_json(json)
      json.set! :user_points do
        json.array! self.user_points do |user_point|
          json.id user_point.id
          json.reason user_point.reason
          json.points user_point.points
          json.operation user_point.operation
        end
      end

    end
  end

end