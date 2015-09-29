ActiveAdmin.register Merchant do
  # Remove Create New Deal button
  config.clear_action_items!

  menu :parent => "Merchant", :priority => 1
  actions :all, except: [:edit]

  filter :venues
  filter :deals
  filter :email
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
    column :current_sign_in_at
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


end
