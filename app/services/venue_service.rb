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

    # get user list by venue, it returns Users
    def wishes_by_venue(venue_id)
      User.joins(:wishes).where('wishes.venue_id' => venue_id)
    end

    def get(id, user_id = nil)
      venue = Venue.find(id)
      build_venue(venue,user_id)
    end

    def build_venue(venue,user_id)
      venue.is_wishlist = WishService.is_wish?(venue.id, user_id) if user_id
      venue
    end

    def get_active_deals_for_venue(venue_id)
      Deal.joins(:deal_venues).where('deal_venues.venue_id' => venue_id).where("active = ? AND expiry_date >= ?", true, Date.today)
    end

    def get_active_and_past_deals_for_venue (venue_id)
      Deal.joins(:deal_venues).where('deal_venues.venue_id' => venue_id, :active => true)
    end

    def get_active_and_past_deals_for_venue_that_are_redeemable (venue_id)
      Deal.joins(:deal_venues).where('deal_venues.venue_id' => venue_id, :active => true, :redeemable => true)
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
