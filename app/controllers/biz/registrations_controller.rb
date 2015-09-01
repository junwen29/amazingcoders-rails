class Biz::RegistrationsController < Devise::RegistrationsController

  include Burpple::ControllerHelper
  include Burpple::BizControllerHelper
  
  layout 'biz/application'

  def after_sign_up_path_for(resource)
    biz_dashboard_path  
  end

  def after_sign_in_path_for(resource)
    biz_dashboard_path  
  end

  def new
    build_resource({})
    respond_with self.resource
  end
  
  def create
    devise_parameter_sanitizer.for(:sign_up) { |u| 
      u.permit(:email, :password)
    }
    build_resource(sign_up_params)

    if resource.save
      distinct_id = resource.id
      Resque.enqueue(AnalyticsJobs::BizAlias, distinct_id, cookies['km_ai']) if cookies['km_ai']
      biz_track_event("signed up", {distinct_id: distinct_id, _d: 1, _t: resource.created_at}, true)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource

      error_messages = []
      resource.errors.messages.each do |k,v|
        error_messages << k.to_s.capitalize + " " + v.join(', ')
      end
      flash.now[:alert] = error_messages
      render :new
    end
  end
end
