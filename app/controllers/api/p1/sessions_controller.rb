class Api::P1::SessionsController < Devise::SessionsController
  # skip_before_filter :verify_authenticity_token,
  #                    :if => Proc.new { |c| c.request.format == 'application/json' }

  prepend_before_filter :require_no_authentication, :only => :create
  prepend_before_filter :allow_params_authentication!, :only => :create

  include Burpple::ApiHelper

  respond_to :json

  # don't remove this override, because if you access create method after logout, you are redirected to /accounts without login
  def require_no_authentication
    session["warden.user.user.key"] = nil
    super
  end

  def create
    # warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # render :status => 200,
    #        :json => { :success => true,
    #                   :info => "Logged in",
    #                   :data => { :auth_token => current_user.authentication_token } }

    request.params[:user] = {}
    request.params[:user][:email]    = params[:email]
    request.params[:user][:password] = params[:password]

    user = warden.authenticate!(auth_options)
    sign_in(User, user)

    render_jbuilder do |json|
      user.to_auth_json(json)
    end
  end

  def destroy
    # warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # current_user.update_column(:authentication_token, nil)
    # render :status => 200,
    #        :json => { :success => true,
    #                   :info => "Logged out",
    #                   :data => {} }
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    head_ok
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end

  def get_owner
    user = User.find_by_authentication_token params[:auth_token]
    render_jbuilder do |json|
      user.to_show_owner(json)
    end
  end
end