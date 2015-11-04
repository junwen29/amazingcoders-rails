module Notification::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.id         self.id
      json.item_type  self.item_type
      json.item_id    self.item_id
      json.item_name  self.item_name
      json.message    self.message
      json.created_at self.created_at.strftime("%Y-%m-%dT%H:%M:%SZ%Z")
    end

  end
end