class UserQuery < ActiveRecord::Base

  def self.save(query, type)
    user_query = UserQuery.where(:query => query, :query_type => type).first

    unless user_query
      user_query = UserQuery.new
      user_query.query = query
      user_query.query_type = type
    end
    user_query.increment(:num_count).save
    return user_query
  end

end
