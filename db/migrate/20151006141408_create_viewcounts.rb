class CreateViewcounts < ActiveRecord::Migration
  def change
    create_table :viewcounts do |t|
      t.belongs_to :deal, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
