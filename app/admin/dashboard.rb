ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      # Show analytic figures for this month
      date = Date.today.end_of_month
      @deal_subscription_count = PaymentService.count_active_premiums(date, 1)
      @total_premiums = PaymentService.get_premiums_pro_rated(Date.today)
      @active_deals = DealService.count_all_active_deals
      @redemption_count = RedemptionService.count_all_redemptions(Date.today.beginning_of_month, date)

      column do
        render partial: 'admin/analytics_dashboard',
               :locals => {
                   :deal_subscription_count => @deal_subscription_count,
                   :premiums => @total_premiums,
                   :active_deals => @active_deals,
                   :redemption_count => @redemption_count
               }
      end
    end

    panel "Recent Deals" do
      table_for Deal.active.order("created_at desc").limit(10) do
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


    panel "Recent Redemptions" do
      table_for Redemption.order("created_at desc").limit(10) do
        column "Deal" do |r|
          auto_link r.deal
        end
        column "User" do |r|
          auto_link r.user
        end
        column "Venue" do |r|
          Venue.find(r.venue_id).name
        end
        column "Redeemed on" do |r|
          r.created_at.localtime.strftime("%B %d, %Y %H:%M")
        end
      end
      strong {link_to "View all Redemptions", admin_redemptions_path}
    end

  end # content
end
