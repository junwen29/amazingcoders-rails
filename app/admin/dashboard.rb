ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

=begin
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
=end

    columns do
      date = Date.today.beginning_of_month
      @deal_subscription_count = PaymentService.count_active_premiums(date, 1)
      @total_premiums = PaymentService.get_total_payments()
      @active_deals = DealService.count_all_active_deals()
      # TODO: Add dashboard figure for redeemed deals

      column do
        render partial: 'admin/analytics_dashboard',
               :locals => {
                   :deal_subscription_count => @deal_subscription_count,
                   :premiums => @total_premiums,
                   :active_deals => @active_deals
               }
      end
    end

    panel "Recent Deals" do
      table_for Deal.order("created_at desc").limit(5) do
        column "Title", :title do |deal|
          link_to deal.title, admin_deal_path(deal)
        end
        column "Merchant", :merchant_id do |deal|
          auto_link deal.merchant
        end
        column "Venues" do |deal|
          deal.venues.map{|v| v.name }.join(", ").html_safe
        end
        column "Active Date", :start_date
        column "Expiry Date", :expiry_date
        column "Created At", :created_at
      end
      strong {link_to "View all Deals", admin_deals_path}
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
