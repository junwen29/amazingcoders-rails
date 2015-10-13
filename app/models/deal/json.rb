module Deal::Json
  extend ActiveSupport::Concern

  included do

    # json is jbuilder
    def to_simple_json(json, options = {})
      json.id             self.id
      json.title          self.title
      json.redeemable     self.redeemable unless self.redeemable == nil
      json.multiple_use   self.multiple_use unless self.multiple_use == nil
      json.type_of_deal   self.type_of_deal
      json.description    self.description
      json.t_c            self.t_c
      json.num_of_redeems self.num_of_redeems
      json.start_date     self.start_date
      json.expiry_date    self.expiry_date
      json.is_bookmarked  self.is_bookmarked unless self.is_bookmarked == nil
    end

    def to_json(json, options = {})
      self.to_simple_json(json, options)

      venues_json json
    end

    def venues_json(json)
      json.set! :venues do
        json.array! self.venues do |venue|
          json.id             venue.id
          json.name             venue.name
          json.neighbourhood  venue.neighbourhood
        end
      end
    end

  end

end