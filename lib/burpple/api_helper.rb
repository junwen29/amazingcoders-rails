module Burpple

  # this module is for incoming request
  module Params

    def bool(val = nil)
      return val.to_i == 1
    end

    # "1,2" => [1,2]
    def to_array(val = nil)
      if val and val.class == String
        val = val.split(",")
      end
      val
      if val
        val.collect do |v|
          v.to_i
        end
      end
    end

    def ll
      _ll = params[:ll]
      if _ll
        lat, lng = _ll.split(",")
        return lat.to_f, lng.to_f
      else
        nil
      end
    end

    def page()
      p = (params[:page] || 1).to_i
      p == 0 ? 1 : p
    end

    def offset()
      (params[:offset] || 0).to_i
    end

    def limit(def_val = 10)
      val = (params[:limit] || def_val).to_i
      val = def_val if val <= 0 or val > 100
      return val
    end

    def get_current_user_id
      user_signed_in? ? current_user.id : nil
    end

  end

  module JsonResponse

    def render_json(json)
      h = {}
      h[:data] = json
      render :json => h
    end

    def head_ok
      head :ok, :content_type=>'application/json'
    end

    def render_null(status = 200)
      h = Jbuilder.encode { |json|
        json.set! :meta do
          json.code 200
        end
        json.data nil
      }
      unless params[:callback].blank?
        render :json => "#{params[:callback]}(#{h});", :content_type=>'application/json'
      else
        render :json => h, :status => status
      end
    end

    # this is util methods to render json
    def render_jbuilder(status = 200)
      h = Jbuilder.encode { |json|
        json.set! :meta do
          json.code 200
        end
        json.set! :data do
          yield(json)
        end
      }

      _render(h)
    end

    # should_render = false to allow for caching json output
    def render_jbuilders(array,meta = nil,should_render = true)
      h = Jbuilder.encode { |json|

        json.set! :meta do
          json.code 200
          if meta
            json.next_max_timestamp meta[:next_max_timestamp] if meta[:next_max_timestamp]
            json.total_count meta[:total_count] if meta[:total_count]
            json.new_notification_count meta[:new_notification_count] if meta[:new_notification_count]
          end
        end

        json.set! :data do
          json.array! array do |object|
            yield(json,object)
          end
        end
      }

      should_render ? _render(h) : h
    end

    def _render(h)
      unless params[:callback].blank?
        render :json => "#{params[:callback]}(#{h});", :content_type=>'application/json'
      else
        render :json => h
      end
    end

  end

  module ErrorResponse

    def combine_messages(messages)
      msg = []
      messages.each {|key, value|
        msg << "#{key}:#{value[0]}"
      }
      msg.join(', ')
    end

    def render_error_json(e)
      error = {}
      error[:type]    = e.type
      error[:message] = e.message
      error[:code]    = e.httpcode

      h = {}
      h[:error] = error
      render :json => h, :status => error[:code]
    end

    # https://github.com/nov/fb_graph/blob/master/lib/fb_graph/exception.rb
    def facebook_invalid_error(e)
      error = {}
      error[:type] = "Facebook Login Error"
      error[:message] = e.message
      error[:code] = e.status

      h = {}
      h[:error] = error
      render :json => h, :status => error[:code]
    end

    #### deprecated

    def render_error_response(status = :internal_server_error, message = '')
      h = {}
      error = {}
      if status == :internal_server_error

        error[:type] = "Internal Server Error"
        error[:message] = 'something wrong please try again'
        error[:code] = 500
      elsif status == :forbidden

        error[:type] = "Forbidden"
        error[:message] = 'something wrong please try again'
        error[:code] = 403
      elsif status == :bad_request

        error[:type] = "Bad Request"
        error[:message] = message
        error[:code] = 400
      elsif status == :not_found

        error[:type] = "Not Found"
        error[:message] = "not found"
        error[:code] = 404
      elsif status == :conflict

        error[:type] = "Conflict"
        error[:message] = "Conflict"
        error[:code] = 409
      end

      h[:error] = error
      render :json => h, :status => error[:code]
    end

    def standard_error(e)
      Rails.logger.error e.message
      Rollbar.error e
      render_error_response(:internal_server_error)
    end

    def record_not_found(e)
      render_error_response(:not_found, e.message)
    end

    def active_record_error(e)
      Rollbar.error e
      render_error_response(:internal_server_error, e.message)
    end

    # def status_forbidden(e)
    #   render_error_response(:forbidden, e.message)
    # end
    # 
    # def status_400(e)
    #   render_error_response(:bad_request, e.message)
    # end
    #   
    # def status_409(e)
    #   render_error_response(:conflict, e.message)
    # end

  end

  module MobileResponse

    def render_error_response(status = :internal_server_error, message = 'something wrong please try again later:(')
      h = {}
      error = {}
      if status == :internal_server_error

        error[:type] = "Internal Server Error"
        error[:message] = message
        error[:code] = 500
      elsif status == :forbidden

        error[:type] = "Forbidden"
        error[:message] = message
        error[:code] = 403
      elsif status == :bad_request

        error[:type] = "Bad Request"
        error[:message] = message
        error[:code] = 400
      elsif status == :not_found

        error[:type] = "Not Found"
        error[:message] = message
        error[:code] = 404
      end
      @error = error

      respond_to do |format|
        format.html { render 'mobile/error', :status => error[:code] , :layout => false }
      end
    end

    def standard_error(e)
      Rails.logger.error e.message
      Rollbar.error e
      render_error_response(:internal_server_error)
    end

    def record_not_found(e)
      render_error_response(:not_found)
    end

    def active_record_error(e)
      Rails.logger.error e.message
      Rollbar.error e
      render_error_response(:internal_server_error)
    end

  end

  module ApiHelper
    include Burpple::Exceptions
    include Burpple::Params
    include Burpple::JsonResponse
    include Burpple::ErrorResponse
  end

  module MobileHelper
    include Burpple::Exceptions
    include Burpple::Params
    include Burpple::MobileResponse
  end

end
