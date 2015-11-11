class ChangeTypeFromStringToTextDeals < ActiveRecord::Migration
  def self.up
    change_column :deals, :description, :text, :limit => nil
    change_column :deals, :t_c, :text, :limit => nil
  end
  def self.down
    change_column :deals, :description, :string
    change_column :deals, :t_c, :string
  end
end
