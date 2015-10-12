class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :points
      t.string :description
      t.string :type
      t.timestamps
    end
  end
end
