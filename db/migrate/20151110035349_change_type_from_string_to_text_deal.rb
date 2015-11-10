class ChangeTypeFromStringToTextDeal < ActiveRecord::Migration
  def change
    change_column :deals, :description, :text, :limit => nil
    change_column :deals, :t_c, :text, :limit => nil
  end
end
