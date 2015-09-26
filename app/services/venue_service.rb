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

    def get_deals_for_venue(venue_id)
      all_deal_venue = DealVenue.where(:venue_id => venue_id)
      active_deals = []
      all_deal_venue.each do |d|
        active_deals << Deal.where('expiry_date > ? AND active = true', d.deal_id, DateTime.now)
      end
      active_deals
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
