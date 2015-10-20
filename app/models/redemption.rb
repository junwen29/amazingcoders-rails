class Redemption < ActiveRecord::Base
  include Redemption::Json

  belongs_to :deal
  belongs_to :user

  def self.save(user_id,deal_id,venue_id)
    redemption = Redemption.new
    redemption.user_id = user_id
    redemption.deal_id = deal_id
    redemption.venue_id = venue_id
    redemption.save

    return redemption

  end
end

