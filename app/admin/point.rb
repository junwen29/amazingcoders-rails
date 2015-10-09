ActiveAdmin.register Point do

  # Allow edit
  permit_params :operation, :burps, :reason, :merchant_id
  actions :all, except: [:show, :destroy]

  # remove_filter :payments, :updated_at
  filter :merchant, as: :select, collection: proc { Merchant.all }
  filter :operation, as: :select, collection: ["Add", "Minus"]
  filter :burps, as: :numeric
  filter :reason, as: :string
  filter :created_at, as: :date_range, label: "Credited at"


  action_item :only => :show do
    link_to "Back", "/admin/merchants"
  end

  # INDEX
  index do
   # selectable_column
    id_column
    column "Merchant", :merchant_id do |point|
      auto_link point.merchant
    end
=begin
    if (:operation == "Add")
      column :burps do |b|
        "+" + b
      end
    else
      column :burps
    end
=end
    column :operation
    column :burps
    column :reason
    column "Credited at", :created_at

    # actions
  end

  # SHOW
  show do |f|
    panel "Point Details" do
      attributes_table_for f do
        row :id
        column :operation
        column :burps
        column :reason
        column :created_at
      end
    end
    active_admin_comments
  end



end