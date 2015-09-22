ActiveAdmin.register AddOn do
  belongs_to :plan

  # Allow edit
  permit_params :name, :cost, :description

  remove_filter :payments, :add_on_payments

  action_item :back do
    link_to "Back", "/admin/plans"
  end


  # INDEX
  index do
    selectable_column
    column :id
    column "Name", :name
    column "Description", :description
    column "Cost", :cost do |plan|
      number_to_currency plan.cost
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
      f.input :addon_type, as: :select, collection: ['Notification','Statistics','Trends']
      f.input :name
      f.input :cost, as: :string, :hint => "No need to specify currency - defaulted to SGD $. Input to 2 decimal places. e.g. 10.00"
      f.input :description
    end
    f.actions
  end


end
