class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :title
      t.string :category
      t.string :content
      t.boolean :resolved

      t.timestamps
    end
  end
end
