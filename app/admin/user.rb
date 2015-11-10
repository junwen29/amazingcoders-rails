ActiveAdmin.register User do
  menu :parent => "User", :priority => 1

  # Remove Create New User button
  config.clear_action_items!
  config.sort_order = "created_at_desc"

  actions :all
  action_item :only => :show do
    link_to "Back", admin_users_path
  end
  batch_action :reward_ROTD, form: {points: :text} do |ids, inputs|
    User.find(ids).each do |user|
      points = inputs['points'].to_i
      reason = "Awarded for Review of the Day"

      point = UserPoint.create(points: points, reason: reason, operation: "Credit", user_id: user.id, created_at: Time.now, updated_at: Time.now)

      tokens = DeviceService.tokens_by_user user.id
      notification = user.notifications.create(item_type: 'user_point',
                                item_id: point.id,
                                item_name: reason,
                                message: 'Congratulations, you have been awarded ' + point.points.to_s + ' burps!')
      NotificationService.send_notification_by_user(notification.id, tokens)
    end
    redirect_to collection_path, alert: "The users have been awarded points for Review of the Day"
  end

  filter :first_name
  filter :last_name
  filter :username
  filter :email
  filter :total_points
  filter :venues, label: 'Wishlists',:collection => proc {(Venue.all).map{|v| [v.name, v.id]}}
  filter :deals, label: 'Bookmarks',:collection => proc {(Deal.active).map{|d| [d.title, d.id]}}

  index do
    selectable_column
    column :first_name
    column :last_name
    column :username
    column :email
    column :total_points
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
      f.input :username, label: 'Username', :input_html => { :disabled => true }
      f.input :email, :input_html => { :disabled => true }
      f.input :total_points, label: 'User Points'
    end
    f.actions
  end

  permit_params :total_points


end
