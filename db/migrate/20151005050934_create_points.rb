class CreatePoints < ActiveRecord::Migration
  def change
    #points refer to the receipt of points
    create_table :points do |t|
      t.string :reason
      t.integer :burps
      t.timestamps
      t.references :merchant
    end
  end
end
