module Venue::Json
  extend ActiveSupport::Concern

  included do

    # json is jbuilder
    def to_simple_json(json, options = {})
      json.name self.name

    end

    def to_json(json, options = {})
      self.to_simple_json(json, options)
    end

  end

end
