module Venue::Json
  extend ActiveSupport::Concern

  included do

    # json is jbuilder
    def to_simple_json(json, options = {})
      json.id             self.id
      json.name           self.name
      json.neighbourhood  self.neighbourhood
      json.is_wishlist    self.is_wishlist unless self.is_wishlist == nil
      json.photo          self.photo.path unless self.photo == nil
    end

    def to_json(json, options = {})
      self.to_simple_json(json, options)
      json.bio            self.bio
      json.street         self.street
      json.zipcode        self.zipcode
      json.phone          self.phone

    end

    def show_json_object (json, options ={})
      self.to_full_json(json, options)
    end

    def to_full_json(json, options ={})
      json.id             self.id
      json.name           self.name
      json.street         self.street
      json.zipcode        self.zipcode
      json.bio            self.bio
      json.neighbourhood  self.neighbourhood
      json.phone          self.phone
      json.contact_number self.contact_number
      json.is_wishlist    self.is_wishlist unless self.is_wishlist == nil
      json.photo          self.photo.path unless self.photo == nil

      deals_json json
    end

    def deals_json(json)
      json.set! :deals do
        json.array! self.deals.active do |deal|
          json.id             deal.id
          json.title          deal.title
          json.type_of_deal   deal.type_of_deal
          json.redeemable     deal.redeemable unless deal.redeemable == nil
          json.image          deal.image.path unless deal.image == nil

        end
      end
    end

  end

end
