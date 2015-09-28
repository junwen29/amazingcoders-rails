class Api::P1::ApplicationController < ApplicationController

  include Burpple::ApiHelper
  before_filter :authenticate_user_from_token!

  # protect_from_forgery, keep this order
  rescue_from StandardError, :with => :standard_error
  rescue_from Exception, :with => :standard_error
  rescue_from ActiveRecord::ActiveRecordError, :with => :active_record_error
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # this error happnes on burpple layer
  rescue_from BurppleError,    :with => :render_error_json

  # because ApplicationController set these filters
  # skip_before_filter :set_locale, :set_timezone, :set_agent
  before_filter :skip_trackable

  # # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  # before_filter :authenticate_user_from_token!

  # def track_event(event_name, properties={}, set_user_properties=false)
  #   super(event_name, :mobile, properties, set_user_properties)
  # end
  #
  # def track_venue_pageview(venues, attributes={})
  #   attributes[:platform] = :mobile
  #   super(venues, attributes)
  # end
  #
  protected

  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

  private
  def authenticate_user_from_token!
    user_token = params[:auth_token].presence
    user       = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user #, store: false
    end
  end
end
