class AddPushDateToDeals < ActiveRecord::Migration
  def change
    def change
      add_column :deals, :push_date, :datetime, :default => nil
    end
  end
end
