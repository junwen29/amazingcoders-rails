class Bookmark < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => :deal_id
  validates_presence_of   :user_id, :deal_id

  after_create do |bookmark|
    expire_cache(bookmark)
  end
  after_destroy do |bookmark|
    expire_cache(bookmark)
  end

  private
  def expire_cache(bookmark)
    Rails.cache.delete([Bookmark.name, User.name, bookmark.user_id, "count"])
    Rails.cache.delete([Bookmark.name, Deal.name, bookmark.deal_id, "count"])
  end

end
