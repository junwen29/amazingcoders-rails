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
      feedback.resolved ? status_tag( "Resolved", :ok ) : status_tag( "Unresolved" )
    end
    actions
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Follow up Feedback" do
      f.input :id, label: 'Ticket ID', :input_html => { :disabled => true }
      f.input :user, :input_html => { :disabled => true }
      f.input :title, label: 'Title', :input_html => { :disabled => true }
      f.input :category, label: 'Category', as: :select, collection: ["Suggestion", "Complaint", "Issue"]
      f.input :content, label: 'Content', :input_html => { :disabled => true }
      f.input :created_at, as: :datepicker, :input_html => { :disabled => true }
      f.input :resolved, label: 'Mark as resolved', as: :radio
    end
    f.actions
  end

  # To comment off
  permit_params :category, :resolved

end
