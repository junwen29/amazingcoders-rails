
class NotificationService

  module ClassMethods

    def send_notification(tokens, item_type,item_id, item_name, message)
      gcm = GCM.new("AIzaSyBGQPh58s2ow6H_OabGrh4vRmzNaNkdRcU")

      options = {data:
                     {message: message, item_type: item_type, item_id: item_id.to_s, item_name: item_name.to_s}
      }

      response = gcm.send(tokens, options)
      return response
    end

  end

  class << self
    include ClassMethods
  end

end