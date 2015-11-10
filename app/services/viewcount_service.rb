class ViewcountService

  module ClassMethods
    def getViewCount(deal_id)
      viewcount = Viewcount.where(:deal_id => deal_id)
      if viewcount.empty?
        0
      else
        viewcount.count
      end
    end

    def get_uniq_view_count(deal_id, date = nil)
      if date == nil
        Viewcount.where(:deal_id => deal_id).select(:user_id).distinct.count
      else
        activate_date = Deal.find(deal_id).activate_date.beginning_of_day
        date = date.to_datetime.end_of_day
        Viewcount.where(:deal_id => deal_id, created_at: activate_date..date).select(:user_id).distinct.count
      end
    end

    def get_uniq_user_id(deal_id, date = nil)
      if date == nil
        Viewcount.where(:deal_id => deal_id).select(:user_id).distinct.pluck(:user_id)
      else
        activate_date = Deal.find(deal_id).activate_date.beginning_of_day
        date = date.to_datetime.end_of_day
        Viewcount.where(:deal_id => deal_id, created_at: activate_date..date).select(:user_id).distinct.pluck(:user_id)
      end
    end

    def setViewCount(deal_id, user_id)
      Viewcount.create(deal_id: deal_id, user_id: user_id)
    end

    def is_unique(deal_id, user_id)
      exist = Viewcount.where('deal_id = ? AND user_id = ?', deal_id, user_id)
      if exist.empty?
        true
      else
        false
      end
    end

  end

  class << self
    include ClassMethods
  end

end