module Redemption::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.id         self.id
      json.created_at self.created_at.strftime("%Y-%m-%dT%H:%M:%SZ%Z")

      json.user do
        self.user.to_json json
      end

      deal = Deal.find(self.deal_id)

      json.deal do
        deal.to_simple_json json
      end

      venue = Venue.find(self.venue_id)

      json.venue do
        venue.to_json json
      end

      # return user point
      unless self.user_point_id.nil?
        user_point = UserPoint.find(self.user_point_id)
        unless user_point.nil?
          json.user_point do
            user_point.to_json json
          end
        end
      end

    end

  end

end
