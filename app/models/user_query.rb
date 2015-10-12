class UserQuery < ActiveRecord::Base
  belongs_to :user

  def self.save(user, query, type)
    user_query = UserQuery.where(:user_id => user.id, :query => query, :query_type => type).first
    unless user_query
      user_query = UserQuery.new
      user_query.user_id = user.id
      user_query.query = query
      user_query.query_type = type
    end
    user_query.increment(:num_count).save
    return user_query
  end

end
