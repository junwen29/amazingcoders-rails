class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :name_of_deal
    	t.boolean :redeemable
    	t.boolean :multiple_use
    	t.string :image
    	t.string :type_of_deal
    	t.string :description
    	t.date :start_date
    	t.date :expiry_date
    	t.string :location
    	t.string :t_c
      t.string :num_of_redeems
			t.string :selected_others
      t.boolean :pushed
      t.timestamps
    end
  end
  end
