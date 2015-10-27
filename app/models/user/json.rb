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
      json.id id
      json.first_name first_name
      json.last_name last_name
      json.username   username

      json.updated_at updated_at
      json.created_at created_at
    end

  end

end