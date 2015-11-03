
class DeviceService

  module ClassMethods

    def tokens_by_venue_wishlist(deal_id)
      # load tokens via users wishes
      tokens = []
      venues = DealService.get_all_venues(deal_id)

      venues.each { |venue|
        users = VenueService.wishes_by_venue(venue.id)
        users.each { |user|
          user.devices.each { |device|
            tokens << device.token
          }
        }
      }
      return tokens #must return tokens
    end
  end

  class << self
    include ClassMethods
  end
end