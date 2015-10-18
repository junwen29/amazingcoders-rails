module Redemption::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.id self.id
      json.created_at self.created_at

      json.user do
        self.user.to_json
      end

      json.deal do
        self.deal.to_simple_json
      end

      venue = Venue.find(:venue_id)

      json.venue do
        venue.to_simple_json json
      end
    end

  end
end
