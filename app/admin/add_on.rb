ActiveAdmin.register AddOn do
  belongs_to :plan
  config.sort_order = "created_at_desc"

  # Allow edit
  permit_params :name, :cost, :description, :addon_type

  filter :plan
  filter :addon_type, as: :select, collection: ["Notification", "Statistics", "Trends"]
  filter :name
  filter :cost
  filter :description
  filter :created_at

  action_item :only => :index do
    link_to "Back to Plans", "/admin/plans"
  end

  action_item :only => :show do
    link_to "Back", admin_plan_add_ons_path
  end


  # INDEX
  index do
    selectable_column
    column :id
    column "Name", :name
    column "Type", :addon_type
    column "Description" do |addon|
      div :class => "descriptionCol" do
        addon.description
      end
    end
    column "Cost", :cost do |addon|
      number_to_currency addon.cost
    end
    column "Plan", :plan_id
    column "Created At", :created_at
    column "Updated At", :updated_at
    actions
  end

  # SHOW
  show do |f|
    panel "Add on Details" do
      attributes_table_for f do
        row :id
        row :plan
        row :name
        row :cost do |add_on|
          number_to_currency add_on.cost
        end
        row "Type" do
          f.addon_type
        end
        row :description
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Add On Information" do
      f.input :addon_type, as: :select, collection: ["Notification","Statistics","Trends"]
      f.input :name
      f.input :cost, as: :string, :hint => "No need to specify currency - defaulted to SGD $. Input to 2 decimal places. e.g. 10.00"
      f.input :description
    end
    f.actions
  end


end
