class DealService

  module ClassMethods

    def get_overlapping_deals(merchant_id, new_start_date, new_expiry_date)
      all_deals = Deal.where(:merchant_id => merchant_id)
      valid_deals = all_deals.where('expiry_date >= ?', DateTime.now)
      overlapping_deals = valid_deals.where('(? <= start_date AND ? >= start_date) OR (? >= start_date AND ? <= expiry_date)',
                                          new_start_date, new_expiry_date, new_start_date, new_start_date)
      overlapping_deals.count
    end

    def num_active_deals (merchant_id, deal)
      all_deals = Deal.where(:merchant_id => merchant_id)
      valid_deals = all_deals.where('expiry_date >= ?', DateTime.now)
      active_deals = valid_deals.where('start_date = ? OR expiry_date = ? OR (start_date < ? AND expiry_date > ?) OR (expiry_date > ? AND active = true)', DateTime.now, DateTime.now, DateTime.now, DateTime.now, DateTime.now)
      active_deals.count
    end

  end

  class << self
    include ClassMethods
  end
end
