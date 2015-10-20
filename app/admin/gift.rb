ActiveAdmin.register Gift do

  # Allow edit
  permit_params :name, :points, :description, :gift_type
  actions :all, except: [:show]

  # remove_filter :payments, :updated_at
=begin
  filter :merchant, as: :select, collection: proc { Merchant.all }
  filter :operation, as: :select, collection: ["Add", "Minus"]
  filter :burps, as: :numeric
  filter :reason, as: :string
  filter :created_at, as: :date_range, label: "Credited at"
=end


  action_item :only => :show do
    link_to "Back", "/admin/gifts"
  end

  # INDEX
  index do
    # selectable_column
    id_column
    column :name
    column :points
    column :description
    column :gift_type
    actions
  end

  # EDIT, NEW
  form do |f|
    f.semantic_errors
    f.inputs "Gift Information" do
      f.input :name
      f.input :points, as: :string, :hint => "State the number of MerchantPoints required to redeem this gift"
      f.input :description
      f.input :gift_type, as: :select, collection: ["Merchant", "User"]
    end
    f.actions
  end

end