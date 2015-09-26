class Api::P1::WishesController < Api::P1::ApplicationController
  # before_filter :authenticate_user!

  # /venues/:id/wishes
  def wishes_by_venue

  end

  # /venues/:id/wishes
  def create
    WishService.wish(venue_id, current_user.id)
    # track_event("Saved To Wishlist", { venue_id: venue_id })
    head_ok
  end

  # /venues/:id/wishes  
  def destroy
    WishService.unwish(venue_id, current_user.id)
    # track_event("Removed From Wishlist", { venue_id: venue_id })
    head_ok
  end

  private

  def venue_id
    params[:id]
  end

end