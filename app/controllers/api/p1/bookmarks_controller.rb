class Api::P1::BookmarksController < Api::P1::ApplicationController
  # before_filter :authenticate_user!

  # /deals/:id/bookmarks
  def bookmarks_by_deals

  end

  # /deals/:id/bookmarks
  def create
    BookmarkService.bookmark(deal_id, current_user.id)
    # track_event("Saved To Bookmark List", { deal_id: deal_id })
    head_ok
  end

  # /deals/:id/bookmarks
  def destroy
    BookmarkService.unbookmark(deal_id, current_user.id)
    # track_event("Removed From Bookmark List", { deal_id: deal_id })
    head_ok
  end

  private

  def deal_id
    params[:id]
  end

end