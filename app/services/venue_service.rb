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
  end

  def get_deals_for_venue(venue_id)
    all_deal_venue = DealVenue.where(:venue_id => venue_id)
    active_deals = []
    all_deal_venue.each do |d|
      active_deals << Deal.where('id = ? AND expiry_date >= ? AND (start_date = ? OR expiry_date = ? OR (start_date < ? AND expiry_date > ?) OR (expiry_date > ? AND active = true))', d.deal_id, DateTime.now, DateTime.now, DateTime.now, DateTime.now, DateTime.now, DateTime.now)
    end
    active_deals
  end

  class << self
    include ClassMethods
  end
end
