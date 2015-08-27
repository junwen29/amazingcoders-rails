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
			t.boolean :monday
			t.time :monday_start
			t.time :monday_end
			t.boolean :tuesday
			t.time :tuesday_start
			t.time :tuesday_end
			t.boolean :wednesday
			t.time :wednesday_start
			t.time :wednesday_end
			t.boolean :thursday
			t.time :thursday_start
			t.time :thursday_end
			t.boolean :friday
			t.time :friday_start
			t.time :friday_end
			t.boolean :saturday
			t.time :saturday_start
			t.time :saturday_end
			t.boolean :sunday
			t.time :sunday_start
			t.time :sunday_end
    	t.string :location
    	t.string :t_c
      t.string :num_of_redeems
			t.string :selected_others
      t.boolean :pushed
      t.timestamps
    end
  end
  end
