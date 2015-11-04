module Gift::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.id self.id
      json.name self.name
      json.points self.points
      json.description self.description
    end

  end

end