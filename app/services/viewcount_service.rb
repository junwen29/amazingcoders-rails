class ViewcountService

  module ClassMethods
    # TODO: Call these methods on Android to update view count
    def getViewCount(deal_id)
      viewcount = Viewcount.where(:deal_id => deal_id)
      if viewcount.empty?
        0
      else
        viewcount.count
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