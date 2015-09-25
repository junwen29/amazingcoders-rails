class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      # t.references :merchant
      t.string :name
      t.string :street
      t.string :zipcode
      t.string :city, :default => "Singapore"
      t.string :state, :default => "Singapore"
      t.string :country, :default => "Singapore"
      t.string :neighbourhood
      t.text :bio
      t.string :phone
      t.boolean :submitted
      t.string :address_2
      #t.attachment :avatar

      t.string :contact_number
      t.string :contact_name
      t.timestamps
    end
  end
end
