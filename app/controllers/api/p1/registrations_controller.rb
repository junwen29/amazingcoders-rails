class Api::P1::RegistrationsController < Devise::RegistrationsController

  include Burpple::ApiHelper

  # skip_before_filter :verify_authenticity_token,
  #                    :if => Proc.new { |c| c.request.format == 'application/json' }
  rescue_from BurppleError,    :with => :render_error_json

  respond_to :json

  def require_no_authentication
    session["warden.user.user.key"] = nil
    super
  end

  def create
    # build_resource
    # resource.skip_confirmation!
    # if resource.save
    #   sign_in resource
    #   render :status => 200,
    #          :json => { :success => true,
    #                     :info => "Registered",
    #                     :data => { :user => resource,
    #                                :auth_token => current_user.authentication_token } }
    # else
    #   render :status => :unprocessable_entity,
    #          :json => { :success => false,
    #                     :info => resource.errors,
    #                     :data => {} }
    # end

    # fb_token = params[:fb_token]
    # facebook signup
    # if fb_token
    #   self.resource = SocialService::FacebookService.new_user_from_token(fb_token)
    #   self.resource.email ||= params[:email] # allow request to specify email in case email from FB fails

    # google signup
    # elsif params[:google_token]
    #   self.resource, social = SocialService::GoogleService.new_user_and_social(params[:google_token])

    # else
    # don't remove request
    # https://github.com/rack/rack/blob/1.5.2/lib/rack/request.rb#L224
    # request.params[:user] = {}
    # request.params[:user][:email]      = request.params[:email]
    # request.params[:user][:password]   = request.params[:password]
    # request.params[:user][:first_name] = request.params[:first_name]
    # request.params[:user][:last_name]  = request.params[:last_name]
    # request.params[:user][:username]   = request.params[:username]

    params[:user] = {}
    params[:user][:email]      = request.params[:email]
    params[:user][:password]   = request.params[:password]
    params[:user][:first_name] = request.params[:first_name]
    params[:user][:last_name]  = request.params[:last_name]
    params[:user][:username]   = request.params[:username]

    # you have to call this method after making user hash
    devise_parameter_sanitizer.for(:sign_up) { |u|
      u.permit(:username, :email, :last_name, :first_name, :password)
    }
    build_resource(sign_up_params)

    # end
    resource = self.resource
    resource.username ||= params[:username]

    saved = nil
    begin
      saved = resource.save

        # you have to call save method after saving user
        # if params[:google_token]
        #   social.user_id = resource.id
        #   social.save
        # end

    rescue ActiveRecord::RecordNotUnique
      saved = false
      resource.errors.add(:email, "has already been taken")
      # even if username is not unique, the flow doesn't come to this part
    end

    if saved

      # check if the user model is active
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
      else #not active
        expire_session_data_after_sign_in!
      end

      render_jbuilder do |json|
        resource.to_auth_json(json)
      end

      # email for registrations has already existed, using the old user account to sign in
    # elsif email_errors = resource.errors.messages[:email] and
    #     email_errors.include? "has already been taken" and
    #     resource = User.find_by_email(resource.email) and
    #     resource and
    #     resource.active_for_authentication? and
    #     resource.valid_password?(params[:password])
    #
    #   sign_in resource_name, resource, :bypass => true
    #   render_jbuilder do |json|
    #     resource.to_auth_json(json)
    #   end

    else
      clean_up_passwords(resource)
      message = resource ? combine_messages(resource.errors.messages) : 'bad request error...'
      raise BadRequestError.new message
    end

  rescue Burpple::Exceptions::BurppleError => e
    Rollbar.error e
    raise e, e.message
  end

end
