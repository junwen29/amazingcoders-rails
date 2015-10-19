ActiveAdmin.register User do
  menu :parent => "User", :priority => 1

  # Remove Create New User button
  config.clear_action_items!
  actions :all, except: [:edit]
  action_item :only => :show do
    link_to "Back", admin_users_path
  end

  filter :first_name
  filter :last_name
  filter :username
  filter :email
  filter :venues, label: 'Wishlists',:collection => proc {(Venue.all).map{|v| [v.name, v.id]}}
  filter :deals, label: 'Bookmarks',:collection => proc {(Deal.active).map{|d| [d.title, d.id]}}

  index do
    selectable_column
    column :first_name
    column :last_name
    column :username
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end


  # SHOW
  show do |f|
    panel "User Details" do
      attributes_table_for f do
        row :id
        row :first_name
        row :last_name
        row :username
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