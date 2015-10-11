ActiveAdmin.register_page "Payment Analytics" do
  menu :parent => "Payment", :priority => 2

  controller do
    def index
      @plan1_name = PlanService.get_plan_names(1)

      analytics_subscription_count()
      analytics_premium_subscribers()
      analytics_premium_profits()
      analytics_subscription_months()
    end

    private
    def analytics_premium_subscribers
      @plan1 = PaymentService.count_plan_payments(1)
      @plan0 = PaymentService.count_total_payments() - @plan1   # Basic plan

      addons = PlanService.get_addon_ids(1)
      @addon_data = Array.new
      addons.each do |a|
        addon = Array.new    # addon consists of [name, subscribers]
        addon.push PlanService.get_addon_names(a)
        addon.push PaymentService.count_addon_payments(a)
        @addon_data.push addon
      end
    end

    private
    def analytics_premium_profits
      @plan1_cost = PaymentService.get_plan_payments(1)

      @addon1_cost = PaymentService.get_addon_payments(1)
      @addon2_cost = PaymentService.get_addon_payments(2)
      @addon3_cost = PaymentService.get_addon_payments(3)

      addons = PlanService.get_addon_ids(1)
      @addon_data = Array.new
      addons.each do |a|
        addon = Array.new    # addon consists of [name, costs]
        addon.push PlanService.get_addon_names(a)
        addon.push PaymentService.get_addon_payments(a)
        @addon_data.push addon
      end
    end

    # Generating subscription count for the past 12 months
    private
    def analytics_subscription_count
      @deal_subscription_count = Array.new    # For y axis
      @months = Array.new                # For x axis
      for i in (0..11).to_a.reverse
        date = Date.today.beginning_of_month.months_ago(i)
        @deal_subscription_count.push PaymentService.count_active_premiums(date, 1)
        @months.push date.strftime("%B")
      end
    end

    # Get months of subscription for each premium service
    private
    def analytics_subscription_months
      @plan1_months = PaymentService.get_plan_months(1)

      # Get drilldown for addons in premium deal plan
      addons = PlanService.get_addon_ids(1)
      @addon_data = Array.new
      addons.each do |a|
        addon = Array.new    # addon consists of [name, month]
        addon.push PlanService.get_addon_names(a)
        addon.push PaymentService.get_addon_months(a)
        @addon_data.push addon
      end
    end
  end

  content do
    render partial: 'admin/analytics_payment'
  end

end