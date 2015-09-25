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

    # Delete active deals that only have that venue
  end

  class << self
    include ClassMethods
  end
end
