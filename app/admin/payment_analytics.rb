ActiveAdmin.register_page "Payment Analytics" do
  menu :parent => "Payment", :priority => 2

  controller do
    def index
      @plan1 = PaymentService.count_plan_payments(1)
      @plan0 = PaymentService.count_total_payments() - @plan1   # Basic plan
      @plan1_cost = PaymentService.get_plan_payments(1)

      @addon1 = PaymentService.count_addon_payments(1)
      @addon2 = PaymentService.count_addon_payments(2)
      @addon3 = PaymentService.count_addon_payments(3)

      @addon1_cost = PaymentService.get_addon_payments(1)
      @addon2_cost = PaymentService.get_addon_payments(2)
      @addon3_cost = PaymentService.get_addon_payments(3)

      # Generating subscription count for the past 12 months
      @deal_subscription_count = Array.new    # For y axis
      @months = Array.new                # For x axis
      for i in (0..11).to_a.reverse
        date = Date.today.beginning_of_month.months_ago(i)
        @deal_subscription_count.push PaymentService.count_active_premiums(date, 1)
        @months.push date.strftime("%B")
        #text_node PaymentService.count_active_premiums(Date.today.beginning_of_month.months_ago(i))
      end
    end
  end

  content do
    render partial: 'admin/analytics_payment'
  end

end