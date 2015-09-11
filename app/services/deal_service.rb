class DealService

  module ClassMethods

    def get_all_venues(merchant_id)
      Venue.where(:merchant_id => merchant_id)
    end

    # for venue
    def get_venue(merchant_id, venue_id)
      Venue.where(:id => venue_id ,:merchant_id => merchant_id).first
    end

    def update_venue(merchant_id, params)
      venue_id = params[:id]
      venue = get_venue(merchant_id, venue_id)

      unless venue
        raise ActiveRecord::RecordNotFound
      end

      venue.update_attributes(add_permit_on_venue(params[:venue]))

      venue
    end



  end

  class << self
    include ClassMethods
  end
end