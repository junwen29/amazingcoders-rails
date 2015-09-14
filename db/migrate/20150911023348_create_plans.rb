class CreatePlans < ActiveRecord::Migration
  def change
    #drop_table :plans
    create_table :plans do |t|
      t.belongs_to  :payment, index: true
      t.string      :name
      t.decimal     :cost, :precision=>8, :scale => 2
      t.string      :description
      t.timestamps
    end
  end
end
