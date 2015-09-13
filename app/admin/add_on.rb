ActiveAdmin.register AddOn do
  menu :parent => "Premium Services", :priority => 2

  # Allow edit
  permit_params :name, :cost, :description

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

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Add On Information" do
      f.input :plan_id
      f.input :name
      f.input :cost, as: :string, :hint => "No need to specify currency - defaulted to SGD $. Input to 2 decimal places. e.g. 10.00"
      f.input :description
    end
    f.actions
  end


end
