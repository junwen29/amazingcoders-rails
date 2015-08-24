class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
  end
  end
