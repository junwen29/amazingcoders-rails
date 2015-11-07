class MerchantService

  module ClassMethods

    # for venues
    def get_all_venues(merchant_id)
      Venue.where(:merchant_id => merchant_id)
    end

    # for venue
    def get_venue(merchant_id, venue_id)
      Venue.where(:id => venue_id ,:merchant_id => merchant_id).first
    end

    # for plan
    def get_deal_plan(merchant_id)
      Payment.where("merchant_id = ? AND start_date <= ? AND expiry_date >= ? AND plan1 = ?", merchant_id, Date.today, Date.today, true).last
    end

    # for analytics
    def get_deal_analytics(merchant_id)
      Payment.where("merchant_id = ? AND start_date <= ? AND expiry_date >= ? AND (add_on2 = ? OR add_on3 = ?)", merchant_id, Date.today, Date.today, true, true).last
    end

    def has_deal_statistics(merchant_id)
      Payment.where("merchant_id = ? AND paid = ? AND start_date <= ? AND expiry_date >= ? AND add_on2 = ? ", merchant_id, true, Date.today, Date.today, true).last
    end

    def has_aggregate_trends(merchant_id)
      Payment.where("merchant_id = ? AND paid = ? AND start_date <= ? AND expiry_date >= ? AND add_on3 = ?", merchant_id, true, Date.today, Date.today, true).last
    end

    # for email
    def get_email(merchant_id)
      merchant = Merchant.find(merchant_id)
      merchant.email
    end

    #for deals
    def get_all_deals(merchant_id)
      Deal.where(:merchant_id => merchant_id)
    end

    def get_all_active_deals(merchant_id)
      Deal.active.where(:merchant_id => merchant_id)
    end

    def get_active_redeemable_deals(merchant_id)
      Deal.active.where(:merchant_id => merchant_id, :redeemable => true)
    end

    def get_all_active_and_past_deals(merchant_id)
      Deal.where(:merchant_id => merchant_id, :active => true)
    end

    def get_active_past_redeemable_deals(merchant_id)
      Deal.where(:merchant_id => merchant_id, :active => true, :redeemable => true)
    end

    def get_past_deals(merchant_id)
      Deal.expired.where(:merchant_id => merchant_id)
    end

    def get_past_redeemable_deals(merchant_id)
      Deal.expired.where(:merchant_id => merchant_id, :redeemable => true)
    end

    def get_active_deals_that_are_active_between_two_dates(merchant_id, start_date, end_date)
      start_date = start_date.to_datetime.in_time_zone("Singapore").beginning_of_day
      end_date = end_date.to_datetime.in_time_zone("Singapore").end_of_day
      MerchantService.get_all_active_deals(merchant_id).where("(activate_date >= ? AND activate_date <= ?) OR (expiry_date >= ? AND expiry_date <= ?) OR (activate_date <= ? AND expiry_date >= ?)", start_date, end_date, start_date, end_date, start_date, end_date)
    end

    def get_past_deals_that_are_active_between_two_dates(merchant_id, start_date, end_date)
      start_date = start_date.to_datetime.in_time_zone("Singapore").beginning_of_day
      end_date = end_date.to_datetime.in_time_zone("Singapore").end_of_day
      MerchantService.get_past_deals(merchant_id).where("(activate_date >= ? AND activate_date <= ?) OR (expiry_date >= ? AND expiry_date <= ?) OR (activate_date <= ? AND expiry_date >= ?)", start_date, end_date, start_date, end_date, start_date, end_date)
    end

    #for MerchantPoints
    def get_all_points(merchant_id)
      MerchantPoint.where(:merchant_id => merchant_id)
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

    def add_permit_on_venue(params)
      if params
        params.permit(:name, :street, :zipcode, :city, :state, :country,
                      :neighbourhood, :bio, :phone, :address_2, :avatar)
      end
    end

    def add_permit_on_merchant(params)
      if params
        params.permit(:name, :designation, :telephone)
      end
    end


  end

  class << self
    include ClassMethods
  end
end
