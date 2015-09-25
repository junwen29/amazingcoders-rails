module Venue::Json
  extend ActiveSupport::Concern

  included do

    # json is jbuilder
    def to_simple_json(json, options = {})
      json.name self.name
      json.id self.id
    end

    def to_json(json, options = {})
      self.to_simple_json(json, options)
    end

    def show_json_object (json, options ={})
      self.to_full_json(json, options)
    end

    def to_full_json(json, options ={})
      json.id self.id
      json.name self.name
      json.street self.street
      json.zipcode self.zipcode
      json.bio self.bio
      json.neighbourhood self.neighbourhood
      json.phone self.phone
      json.contact_number json.contact_number
    end

  end

end
