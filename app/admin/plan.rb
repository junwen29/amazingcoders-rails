ActiveAdmin.register Plan do
  # Allow edit
  permit_params :name, :cost, :description

  # Sidebar
  sidebar "Plan Add Ons" do
    ul do
      li link_to "See Add Ons", admin_plan_add_ons_path(plan)
    end
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
    column "Created At", :created_at
    column "Updated At", :updated_at
    actions
  end

  # SHOW
  show do |f|
    panel "Plan Information" do
      attributes_table_for f do
        row :id
        row :name
        row :cost do |plan|
          number_to_currency plan.cost
        end
        row :description
        row :created_at
        row :updated_at
      end
    end
  end


  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Plan Information" do
      f.input :name
      f.input :cost, as: :string, :hint => "No need to specify currency - defaulted to SGD $. Input to 2 decimal places. e.g. 10.00"
      f.input :description
    end
    f.actions
  end

end
