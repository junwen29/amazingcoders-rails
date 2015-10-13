class CreateUserQueries < ActiveRecord::Migration
  def change
    create_table :user_queries do |t|
      t.string  :query
      t.integer :num_count
      t.string  :query_type

      t.timestamps
    end
  end
end
