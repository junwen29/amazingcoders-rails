ActiveAdmin.register MerchantFeedback do
  menu :parent => "Merchant", :priority => 4

  config.clear_action_items!
  config.sort_order = "created_at_desc"

  actions :all, except: [:destroy]
  action_item :only => :show do
    link_to "Back", "/admin/merchant_feedbacks"
  end

  scope :all
  scope :resolved
  scope :unresolved

  filter :merchant, as: :select, collection: proc { Merchant.all }
  filter :category, as: :select, collection: ["Suggestion", "Complaint", "Issue"]
  filter :title, as: :string
  filter :resolved, as: :boolean
  filter :created_at, as: :date_range

  batch_action "Resolve" do |ids|
    MerchantFeedback.find(ids).each do |feedback|
      feedback.update(resolved: true)
    end
    redirect_to collection_path, alert: "The feedbacks have been marked as resolved."
  end

  index do
    selectable_column
    column :id
    column "Merchant", :merchant_id do |feedback|
      auto_link feedback.merchant
    end
    column :title
    column :category
    column "Content" do |feedback|
      div :class => "descriptionCol" do
        feedback.content
      end
    end
    column :created_at
    column "Status", :resolved do |feedback|
      feedback.resolved ? status_tag( "Resolved", :ok ) : status_tag( "Unresolved" )
    end
    actions
  end

  # SHOW
  show do |f|
    panel "Merchant Feedback Details" do
      attributes_table_for f do
        row "Ticket ID" do
          f.id
        end
        row :title
        row :category
        row :content
        row "Status" do
          f.resolved ? status_tag( "Resolved", :ok ) : status_tag( "Unresolved" )
        end
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Follow up Feedback" do
      f.input :id, label: 'Ticket ID', :input_html => { :disabled => true }
      f.input :merchant, :input_html => { :disabled => true }
      f.input :title, label: 'Title', :input_html => { :disabled => true }
      f.input :category, label: 'Category', as: :select, collection: ["Suggestion", "Complaint", "Issue"]
      f.input :content, label: 'Content', :input_html => { :disabled => true }
      f.input :created_at, as: :datepicker, :input_html => { :disabled => true }
      f.input :resolved, label: 'Mark as resolved', as: :radio
    end
    f.actions
  end

  permit_params :category, :resolved

end
