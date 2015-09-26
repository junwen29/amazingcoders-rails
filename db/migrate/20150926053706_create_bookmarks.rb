class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :user
      t.references :deal
      t.integer :user_id
      t.integer :deal_id

      t.timestamps
    end
  end
end
