class Merchants::SessionsController < Devise::SessionsController

  def after_sign_up_path_for(resource)
    session[:merchant_id] = merchant_id
    venues_path
  end

  def after_sign_in_path_for(resource)
    session[:merchant_id] = merchant_id
    venues_path
  end

  # before_filter :configure_sign_in_params, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end