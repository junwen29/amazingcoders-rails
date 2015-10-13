ActiveAdmin.register DealAnalytic do
  menu :parent => "Deals", :priority => 2

  config.clear_action_items!

  action_item :only => :show do
    link_to "Back", "/admin/deal_analytics"
  end

  # Show only active deals
  filter :deal, label: "Deals", :collection => proc {(Deal.active).map{|d| [d.title, d.id]}}
  filter :view_count, label: "Views"
  filter :unique_view_count, label: "Unique Views"
  filter :redemption_count, label: "Redemptions"

  index do
    selectable_column
    column "Deal Id", :deal_id
    column "Deal Title" do |da|
      auto_link da.deal
    end
    column "Start Date" do |da|
      da.deal.start_date
    end
    column "Expiry Date" do |da|
      da.deal.expiry_date
    end
    column "Views" do |da|
      div :class => "numberCol" do
        da.view_count
      end
    end
    column "Unique Views" do |da|
      div :class => "numberCol" do
        da.unique_view_count
      end
    end
    column "Redemptions" do |da|
      div :class => "numberCol" do
        da.redemption_count
      end
    end
    actions
  end

  show do |f|
    panel "Deal Information" do
      attributes_table_for f do
        row "Deal Id" do
          f.deal_id
        end
        row "Deal Title" do
          f.deal
        end
        row "Deal Description" do
          f.deal.description
        end
        row "Start Date" do
          f.deal.start_date
        end
        row "Expiry Date" do
          f.deal.expiry_date
        end
        row "Merchant" do
          f.deal.merchant
        end
        row "Venues" do
          f.deal.venues.map{|v| v.name }.join(", ").html_safe
        end
      end
    end

    panel "Deal Analytics" do
      attributes_table_for f do
        row :view_count
        row :unique_view_count
        row :redemption_count
      end
    end

    active_admin_comments # Add this line for comment block
  end

  form do |f|
    f.inputs "Deal Information" do
      f.input :deal_id, :input_html => { :disabled => true }
      f.input :deal, :input_html => { :disabled => true }
    end

    f.inputs "Deal Analytics" do
      f.input :view_count
      f.input :unique_view_count
      f.input :redemption_count
    end
    f.actions
  end

  # TODO: Add charts to new route
  collection_action :charts, :method=>:get do

  end

  action_item :only => :index do
    link_to "View Charts", charts_admin_deal_analytics_path
  end

  controller do
    def charts
      render partial: 'admin/analytics_payment'
    end
  end

end
