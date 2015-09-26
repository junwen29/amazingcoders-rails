
class BookmarkService
  module ClassMethods

    def bookmark(deal_id, user_id)
      unless Deal.exists?(deal_id)
        raise ActiveRecord::RecordNotFound
      end

      bookmark = Bookmark.where(deal_id:deal_id, user_id: user_id).first
      if bookmark ## if you have already bookmark, you can't.
        return bookmark
      end
      return Bookmark.create!(deal_id:deal_id, user_id: user_id)
    end

    def unbookmark(deal_id, user_id)
      bookmark = Bookmark.where(deal_id:deal_id, user_id: user_id)
      if bookmark.size == 0
        raise ActiveRecord::RecordNotFound
      else
        if bookmark.destroy_all
          return true
        else
          raise ActiveRecord::ActiveRecordError
        end
      end
    end

    # sets deal.is_bookmarked for list of deals
    def set_is_bookmarked(deals, user_id)
      return deals if user_id.nil?

      if deals.respond_to?(:each)
        deal_ids = Bookmark.where(user_id: user_id).pluck(:deal_id)
        deals.each do |d|
          d.is_bookmarked = deal_ids.include?(d.id)
        end
      else
        deals.is_bookmarked = is_bookmarked?(deals.id, user_id)
      end
      deals
    end

    # to check if a user did bookmark the deal or not
    def is_bookmarked?(deal_id, user_id)
      Bookmark.exists?(deal_id:deal_id, user_id: user_id)
    end

    # return all deals bookmarked by user
    def deals_by_user(user_id)
      deals = Deal.joins(:bookmarks).where('bookmarks.user_id' => user_id).order('bookmarks.created_at DESC')
      deals
    end

  end

  class << self
    include ClassMethods
  end

end