ActiveAdmin.register Merchant do
  # Remove Create New Deal button
  config.clear_action_items!
  config.sort_order = "created_at_desc"

  menu :parent => "Merchant", :priority => 1
  actions :all

  filter :venues
  filter :deals
  filter :email
  filter :total_points
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  action_item :only => :show do
    link_to "Back", "/admin/merchants"
  end

  # INDEX
  index do
    selectable_column
    id_column
    column :email
    column :total_points
    column :sign_in_count
    column :created_at
    actions
  end

  # SHOW
  show do |f|
    panel "Merchant Details" do
      attributes_table_for f do
        row :id
        row :email
        row :total_points
        row :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Edit points" do
      f.input :id, label: 'Merchant ID', :input_html => { :disabled => true }
      f.input :email, :input_html => { :disabled => true }
      f.input :total_points, label: 'Merchant Points'
    end
    f.actions
  end

  permit_params :total_points

end
