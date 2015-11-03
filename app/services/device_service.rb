
class DeviceService

  module ClassMethods

    #return users' id and tokens
    def tokens_by_venue_wishlist(deal_id)
      # load tokens via users wishes
      tokens = []
      user_ids = []

      venues = DealService.get_all_venues(deal_id)
      venues.each { |venue|
        users = VenueService.wishes_by_venue(venue.id)
        users.each { |user|
          user_ids << user.id
          user.devices.each { |device|
            tokens << device.token
          }
        }
      }
      return user_ids, tokens #must return tokens
    end
  end

  class << self
    include ClassMethods
  end
end