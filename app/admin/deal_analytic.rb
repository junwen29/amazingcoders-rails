ActiveAdmin.register DealAnalytic do
  menu :parent => "Deals", :priority => 3

  config.clear_action_items!
  config.sort_order = "created_at_desc"
  actions :all, except: [:edit]

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
      div :class => "descriptionCol" do
        auto_link da.deal
      end
    end
    column "Start Date" do |da|
      da.deal.start_date
    end
    column "Expiry Date" do |da|
      da.deal.expiry_date
    end
    column "Views", sortable: "view_count" do |da|
      div :class => "numberCol" do
        da.view_count
      end
    end
    column "Unique Views", sortable: "unique_view_count" do |da|
      div :class => "numberCol" do
        da.unique_view_count
      end
    end
    column "Redemptions", sortable: "redemption_count" do |da|
      div :class => "numberCol" do
        da.redemption_count
      end
    end
    actions
  end

  show do |f|
    panel "Deal Associations" do
      attributes_table_for f do
        row "Merchant" do
          f.deal.merchant
        end
        row "Venues" do
          f.deal.venues.map{|v| v.name }.join(", ").html_safe
        end
      end
    end

    panel "Deal Info" do
      attributes_table_for f.deal do
        row :title
        row :type_of_deal
        row :description
        row "Terms and Conditions" do
          f.deal.t_c
        end
      end
    end

    panel "Deal Schedule" do
      attributes_table_for f do
        row "Start Date" do
          f.deal.start_date
        end
        row "Expiry Date" do
          f.deal.expiry_date
        end
      end
    end

    panel "Deal Status" do
      attributes_table_for f do
        row "Deal Activated?" do
          f.deal.active ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
        row "Notification Pushed?" do
          f.deal.pushed ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
      end
    end

    panel "Deal Redemption" do
      attributes_table_for f do
        row "Number of Redeems" do
          f.deal.num_of_redeems
        end
        row "Multiple Use?" do
          f.deal.multiple_use ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
      end
    end

    panel "Deal Add-ons" do
      attributes_table_for f do
        row "QR Code Redeemable?" do
          f.deal.redeemable ? status_tag( "yes", :ok ) : status_tag( "no" )
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

  collection_action :charts, :method=>:get do

  end

  action_item :only => :index do
    link_to "View Charts", charts_admin_deal_analytics_path
  end

  action_item :only => :charts do
    link_to "Back", "/admin/deal_analytics"
  end


  controller do
    def charts
      # show views/admin/deal_analytics/charts.html.erb

      # Deal traffic
      end_date = Time.now
      start_date = end_date.beginning_of_year
      @view_counts = DealAnalyticService.get_app_traffic(start_date, end_date)
      @redemption_counts = DealAnalyticService.get_foot_traffic(start_date, end_date)

      # Popular deal types
      @popular_deal_types = DealAnalyticService.get_overall_popular_deal_type

      # Popular keywords
      @queries = DealAnalyticService.get_top_queries(10).as_json
    end
  end

end
