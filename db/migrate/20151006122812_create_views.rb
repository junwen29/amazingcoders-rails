class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.belongs_to :deal, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
