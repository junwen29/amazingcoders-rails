module Redemption::Json
  extend ActiveSupport::Concern

  included do

    def to_simple_json(json)
      json.id         self.id
      json.created_at self.created_at

      json.deal do
        self.deal.to_simple_json json
      end

      venue = Venue.find(self.venue_id)

      json.venue do
        venue.to_simple_json json
      end

    end

    def to_json(json, options = {})
      json.id         self.id
      json.created_at self.created_at

      json.user do
        self.user.to_json json
      end

      json.deal do
        self.deal.to_simple_json json
      end

      venue = Venue.find(self.venue_id)

      json.venue do
        venue.to_json json
      end
    end

  end
end
