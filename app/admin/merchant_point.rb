ActiveAdmin.register MerchantPoint do
  config.sort_order = "created_at_desc"

  menu :parent => "Merchant", :priority => 3

  # Allow edit
  permit_params :operation, :points, :reason, :merchant_id
  actions :all, except: [:show, :destroy]

  scope :all
  scope :credit
  scope :debit

  # remove_filter :payments, :updated_at
  filter :merchant, as: :select, collection: proc { Merchant.all }
  filter :operation, as: :select, collection: ["Credit", "Debit"]
  filter :points, as: :numeric
  filter :reason, as: :string
  filter :created_at, as: :date_range, label: "Changed at"


  action_item :only => :show do
    link_to "Back", "/admin/merchants"
  end

  # INDEX
  index do
    selectable_column
    id_column
    column "Merchant", :merchant_id do |point|
      auto_link point.merchant
    end
    column :operation
    column :points
    column "Reason" do |point|
      div :class => "descriptionCol" do
        point.reason
      end
    end
    column "Changed at", :created_at
    # actions
  end

  # SHOW
  show do |f|
    panel "MerchantPoint Details" do
      attributes_table_for f do
        row :id
        column :operation
        column :points
        column :reason
        column :created_at
      end
    end
    active_admin_comments
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "MerchantPoint Details" do
      f.input :merchant
      f.input :reason
      f.input :points, as: :string, :hint => "Please input an integer value"
      f.input :operation, as: :select, collection: ["Credit", "Debit"]
    end
    f.actions
  end

end