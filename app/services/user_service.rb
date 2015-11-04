class UserService
  module ClassMethods

    def get_num_wishes(user_id)
      Wish.where(:user_id => user_id).count
    end

    def get_num_bookmarks(user_id)
      Bookmark.where(:user_id => user_id).count
    end

    def get_owner(username)
      user = User.where(:authentication_token => username)
      user
    end

  end

  class << self
    include ClassMethods
  end

end