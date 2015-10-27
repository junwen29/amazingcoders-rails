class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.string      :title
      t.string      :category
      t.text        :content
      t.boolean     :resolved, :default  => false
      t.belongs_to  :user, index: true

      t.timestamps
    end
  end
end
