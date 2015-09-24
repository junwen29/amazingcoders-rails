class Api::P1::DevicesController < Api::P1::ApplicationController
  # before_action :authenticate_user!

  def create
    device_token = params[:device_token]
    device_type  = params[:device_type]
    auth_token = params[:auth_token]
    if device_token
      user = User.find_by_authentication_token auth_token
      device = Device.save(user, device_token, device_type)
      if device.persisted?
        head_ok
        return
      end
    end
    render_error_response(:bad_request)
  end

  def destroy
    Device.destroy(current_user, params[:device_token], params[:device_type])
    head_ok
  end

end