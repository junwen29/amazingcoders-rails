class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :merchantfeedbacks do |t|
      t.string :title
      t.string :category
      t.string :content

      t.timestamps
    end
  end
end
