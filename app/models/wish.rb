class Wish < ActiveRecord::Base
  belongs_to :venue
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => :venue_id
  validates_presence_of   :user_id, :venue_id

  after_create do |wish|
    expire_cache(wish)
  end
  after_destroy do |wish|
    expire_cache(wish)
  end

  private
  def expire_cache(wish)
    Rails.cache.delete([Wish.name, User.name, wish.user_id, "count"])
    Rails.cache.delete([Wish.name, Venue.name, wish.venue_id, "count"])
  end

end
