ActiveAdmin.register Gift do
  config.sort_order = "created_at_desc"

  # Allow edit
  permit_params :name, :points, :description, :gift_type
  actions :all, except: [:show]

  scope :all
  scope :merchant
  scope :user

  filter :name
  filter :points
  filter :description
  filter :gift_type, as: :select, collection: ["Merchant", "User"]
  filter :created_at

  action_item :only => :show do
    link_to "Back", "/admin/gifts"
  end

  # INDEX
  index do
    selectable_column
    id_column
    column :name
    column :points
    column "Description" do |gift|
      div :class => "descriptionCol" do
        gift.description
      end
    end
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