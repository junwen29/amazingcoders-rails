ActiveAdmin.register UserFeedback do
  menu :parent => "User", :priority => 3

  config.clear_action_items!
  actions :all, except: [:show, :destroy]

  filter :user, as: :select, collection: proc { User.all }
  filter :category, as: :select, collection: ["Suggestion", "Complaint", "Issue"]
  filter :title, as: :string
  filter :resolved, as: :boolean
  filter :created_at, as: :date_range


  index do
    selectable_column
    column :id
    column "User", :user_id do |feedback|
      auto_link feedback.user
    end
    column :title
    column :category
    column :content
    column :created_at
    column "Status", :resolved do |feedback|
      feedback ? status_tag( "Resolved", :ok ) : status_tag( "Unresolved" )
    end
    actions
  end

  # To comment off
  permit_params :category, :content, :title, :resolved, :user_id

end
