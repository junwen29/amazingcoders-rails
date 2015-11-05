module UserFeedback::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.title      self.title
      json.category   self.category
      json.content    self.content
      json.resolved   self.resolved
    end

  end
end
