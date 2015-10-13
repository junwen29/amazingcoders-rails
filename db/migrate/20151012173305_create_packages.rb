class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :points
      t.string :description
      t.string :package_type
      t.timestamps
    end
  end
end
