class VenueService

  module ClassMethods
    # Get all wishlisted users
    def get_wishlisted_users(venue_id)
      wishlisted = Wishlist.where(:venue_id => venue_id).select(:user_id)
      users = []
      wishlisted.each do |f|
        user = User.find(f.user_id)
        users << user
      end
      users
    end

    # Prevent deleating of venues when a deal has only that particular venue
    def allow_delete(venue_id)
      deal_venue = DealVenue.where(:venue_id => venue_id)
      deal_venue.each do |dv|
        deals = DealVenue.where('deal_id = ?', dv.deal_id)
        if deals.count == 1
          return false
        end
      end
      true
    end
  end

  class << self
    include ClassMethods
  end
end
