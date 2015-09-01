class Biz::SessionsController < Devise::SessionsController

  prepend_before_filter :require_no_authentication, :only => [ :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create

  layout 'biz/application'
  
  def after_sign_in_path_for(resource)
    biz_dashboard_path
  end

  def after_sign_out_path_for(resource)
    biz_root_path
  end
    
  # GET /resource/sign_in
  def new
    if merchant_signed_in?
      redirect_to biz_dashboard_path
    else
      self.resource = resource_class.new
      clean_up_passwords(resource)
      respond_with(resource, serialize_options(resource))
    end
  end
  
  # /accounts/sign_in
  def create      
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
    
  # /accounts/sign_out
  # override
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

end