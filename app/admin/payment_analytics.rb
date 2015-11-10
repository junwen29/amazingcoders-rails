ActiveAdmin.register_page "Payment Analytics" do
  menu :parent => "Payment", :priority => 2

  controller do
    def index
      @plan1_name = PlanService.get_plan_names(1)

      analytics_subscription_count
      analytics_premium_subscribers
      analytics_premium_profits
      analytics_subscription_months
      analytics_cross_sell
    end

    private
    def analytics_premium_subscribers
      all_plan_ids = Plan.pluck(:id)
      premium_count = 0
      @plan_subscribers_series = Array.new
      @addon_subscribers_series = Array.new

      all_plan_ids.each do |id|
        # Plan: Premiums [name, count, drilldown]
        plan_name = PlanService.get_plan_names(id)
        plan_count = PaymentService.count_plan_payments(id)
        premium_count += plan_count
        plan_data = {name: plan_name, y: plan_count, drilldown: plan_name}.to_json
        @plan_subscribers_series.push plan_data

        # Addons for each plan [name, id, data]
        # 1. Data
        addons = PlanService.get_addon_ids(id)
        addon_data_subscribers = Array.new
        addons.each do |a|
          addon = Array.new    # addon consists of [name, subscribers]
          addon.push PlanService.get_addon_names(a)
          addon.push PaymentService.count_addon_payments(a)
          addon_data_subscribers.push addon
        end
        # 2. Pass json
        addon_json = {name: "Addons", id: plan_name, data: addon_data_subscribers}.to_json
        @addon_subscribers_series.push addon_json
      end

      # Plan: Basic plan -> push to first element of array
      basic_subscribers = PaymentService.count_total_payments - premium_count
      if basic_subscribers < 0
        basic_subscribers = 0
      end
      basic_data = {name: "Basic Service", y: basic_subscribers, drilldown: "null"}.to_json
      @plan_subscribers_series.push basic_data
    end

    private
    def analytics_premium_profits
      all_plan_ids = Plan.pluck(:id)
      @plan_profits_series = Array.new
      @addon_profits_series = Array.new

      all_plan_ids.each do |id|
        # Plan json [name, cost, drilldown]
        plan_name = PlanService.get_plan_names(id)
        plan_cost = PaymentService.get_plan_payments(id).to_f
        plan_json = {name: plan_name, y: plan_cost, drilldown: plan_name}.to_json
        @plan_profits_series.push plan_json

        # Addons for each plan [name, id, data]
        # 1. Get data. [name, costs]
        addons = PlanService.get_addon_ids(id)
        addon_data_profits = Array.new
        addons.each do |a|
          addon = Array.new    # addon consists of [name, costs]
          addon.push PlanService.get_addon_names(a)
          addon.push PaymentService.get_addon_payments(a).to_f
          addon_data_profits.push addon
        end
        # Pass json
        addon_json = {name: "Addons", id: plan_name, data: addon_data_profits}.to_json
        @addon_profits_series.push addon_json
      end

      # Basic plan json {name, cost, drilldown}
      basic_plan_json = {name: "Basic Service", y: 0, drilldown: "null"}.to_json
      @plan_profits_series.push basic_plan_json
    end

    # Generating subscription count for the past 12 months
    private
    def analytics_subscription_count
      all_plan_ids = Plan.pluck(:id)
      @plan_subscriptions_series = Array.new

      all_plan_ids.each do |id|
        # Plan json [name, subscriptions]
        plan_name = PlanService.get_plan_names(id)
        # 1. Get subscriptions
        plan_subscriptions = Array.new    # For y axis
        for i in (0..11).to_a.reverse
          date = Date.today.end_of_month.months_ago(i)
          plan_subscriptions.push PaymentService.count_active_premiums(date, id)
        end
        # 2. Pass json
        plan_json = {name: plan_name, data: plan_subscriptions}.to_json
        @plan_subscriptions_series.push plan_json
      end

      @months = Array.new                # For x axis
      for i in (0..11).to_a.reverse
        date = Date.today.beginning_of_month.months_ago(i)
        @months.push date.strftime("%B")
      end

    end

    # Get months of subscription for each premium service
    private
    def analytics_subscription_months
      all_plan_ids = Plan.pluck(:id)
      @plan_months_series = Array.new
      @addon_months_series = Array.new
      @plan_months_statistics = Array.new

      all_plan_ids.each do |id|
        # Plan json [name, months, drilldown]
        plan_name = PlanService.get_plan_names(id)
        plan_months = PaymentService.get_plan_months(id).to_f
        plan_count = PaymentService.count_plan_payments(id)
        plan_average_months = plan_months / plan_count

        variance = PaymentService.calculate_variance(id, plan_average_months, plan_count)
        sd = Math.sqrt(variance)
        max = PaymentService.get_max_months(id)
        min = PaymentService.get_min_months(id)

        plan_json = {name: plan_name, y: plan_average_months.round(2), drilldown: plan_name, variance: variance.round(3), sd: sd.round(3), max: max, min: min}.to_json
        @plan_months_series.push plan_json

        # Addons for each plan [name, id, data]
        # 1. Get data. [name, months]
        addons = PlanService.get_addon_ids(id)
        addon_data_months = Array.new
        addons.each do |a|
          addon_name = PlanService.get_addon_names(a)
          addon_count = PaymentService.count_addon_payments(a)
          addon_average_months = PaymentService.get_addon_months(a).to_f / addon_count

          variance = PaymentService.calculate_addon_variance(a, addon_average_months, addon_count)
          sd = Math.sqrt(variance)
          max = PaymentService.get_addon_max_months(a)
          min = PaymentService.get_addon_min_months(a)

          addon_json = {name: addon_name, y: addon_average_months.round(2), variance: variance.round(3), sd: sd.round(3), max: max, min: min}
          addon_data_months.push addon_json
        end
        # Pass json
        addon_json = {name: "Addons", id: plan_name, data: addon_data_months}.to_json
        @addon_months_series.push addon_json
      end

    end

    # Get cross selling analytics
    private
    def analytics_cross_sell
      @addon1_name = AddOn.find(1).name
      @addon2_name = AddOn.find(2).name
      @addon3_name = AddOn.find(3).name

      @plan1_with_addon1 = PaymentService.count_plan_addon_cross_sell(1, 1).round(1)
      @plan1_with_addon2 = PaymentService.count_plan_addon_cross_sell(1, 2).round(1)
      @plan1_with_addon3 = PaymentService.count_plan_addon_cross_sell(1, 3).round(1)

      @addon_1_with_2 = ((PaymentService.count_addons_cross_sell(true, true, false).to_f / Payment.count)*100).round(1)
      @addon_1_with_3 = ((PaymentService.count_addons_cross_sell(true, false, true).to_f / Payment.count)*100).round(1)
      @addon_2_with_3 = ((PaymentService.count_addons_cross_sell(false, true, true).to_f / Payment.count)*100).round(1)
    end
  end

  content do
    render partial: 'admin/analytics_payment'
  end

end