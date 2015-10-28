ActiveAdmin.register UserPoint do

  menu :parent => "User", :priority => 2

  # Allow edit
  permit_params :operation, :points, :reason, :user_id
  actions :all, except: [:show, :edit, :destroy]

  filter :user, as: :select, collection: proc { User.all }
  filter :operation, as: :select, collection: ["Credit", "Debit"]
  filter :points, as: :numeric
  filter :reason, as: :string
  filter :created_at, as: :date_range, label: "Changed at"

  action_item :only => :show do
    link_to "Back", "/admin/users"
  end

=begin
  controller do
    def create
      userpoint = params[:user_point]
      user = User.find(userpoint[:user_id])
      user_current_points = user.total_points
      operation = userpoint[:operations]
      new_points = userpoint[:points]
      if user.present? && operation.present? && new_points.present?
        if operation == "Credit"
          user_current_points += new_points
        elsif operation == "debit"
          user_current_points -= new_points
        end
        user.update(total_points: user_current_points)
      else
        flash[:error] = "Failed to create user point!"
      end
    end
  end
=end

  index do
    selectable_column
    column :id
    column "User", :user_id do |point|
      auto_link point.user
    end
    column :operation
    column :points
    column :reason
    column "Changed at", :created_at
  end

  show do
    panel "User Point Details" do
      attributes_table_for f do
        row :id
        row :operation
        row :points
        row :reason
        row :created_at
      end
    end
    active_admin_comments
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "User Point Details" do
      f.input :user
      f.input :reason
      f.input :points, as: :string, :hint => "Please input an integer value"
      f.input :operation, as: :select, collection: ["Credit", "Debit"]
    end
    f.actions
  end


end
