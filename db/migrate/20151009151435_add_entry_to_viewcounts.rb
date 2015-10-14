class AddEntryToViewcounts < ActiveRecord::Migration
  def change
    add_column :viewcounts, :entry, :string
  end
end
