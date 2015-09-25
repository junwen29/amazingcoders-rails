class VenueService

  module ClassMethods
    # Get all wishlisted users
    def get_wishlisted_users(venue_id)
      wishlisted = Wish.where(:venue_id => venue_id).select(:user_id)
      users = []
      wishlisted.each do |f|
        user = User.find(f.user_id)
        users << user
      end
      users
    end

    def get(id, user_id = nil)
      venue = Venue.find(id)
      build_venue(venue,user_id)
    end

    def build_venue(venue,user_id)
      venue.is_wishlist = WishService.is_wish?(venue.id, user_id) if user_id
      venue
    end

  end

  class << self
    include ClassMethods
  end
end
