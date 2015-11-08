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
      @month_year = Date.today.strftime("%B %Y")

      column do
        render partial: 'admin/analytics_dashboard',
               :locals => {
                   :deal_subscription_count => @deal_subscription_count,
                   :premiums => @total_premiums,
                   :active_deals => @active_deals,
                   :redemption_count => @redemption_count,
                   :month_year => @month_year
               }
      end
    end

    panel "Recent Deals" do
      table_for Deal.active.order("created_at desc").limit(10) do
        column "Title", :title do |deal|
          div :class => "descriptionCol" do
            link_to deal.title, admin_deal_path(deal)
          end
        end
        column "Merchant", :merchant_id do |deal|
          auto_link deal.merchant
        end
        column "Venues" do |deal|
          div :class => "descriptionCol" do
            deal.venues.map{|v| v.name }.join(", ").html_safe
          end
        end
        column "Active Date", :start_date
        column "Expiry Date", :expiry_date
        column "Created At", :created_at
      end
      strong {link_to "View all Deals", admin_deals_path}
    end

    panel "Recent Payments" do
      table_for Payment.order("created_at desc").limit(10) do
        column "Merchant", :merchant_id do |payment|
          auto_link payment.merchant
        end
        column "Plan" do |payment|
          if (payment.plan1)
            plan = Plan.find(1)
            auto_link plan
          end
        end
        column "Add Ons" do |payment|
          output = []
          if (payment.add_on1)
            add_on1 = AddOn.find(1)
            output << add_on1.name
          end
          if (payment.add_on2)
            add_on2 = AddOn.find(2)
            output << add_on2.name
          end
          if (payment.add_on3)
            add_on3 = AddOn.find(3)
            output << add_on3.name
          end
          output.join(', ').html_safe
        end
        column "Premium Paid", :total_cost do |payment|
          number_to_currency payment.total_cost
        end
        column "Start Date", :start_date
        column "Expiry Date", :expiry_date
        column "Paid on", :created_at
      end
      strong {link_to "View all Payments", admin_payments_path}
    end

  end # content
end
