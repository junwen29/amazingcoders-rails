ActiveAdmin.register_page "Payment Analytics" do
  menu :parent => "Payment", :priority => 2

  content do
    @plan1 = PaymentService.count_plan_payments(1)
    @plan0 = PaymentService.count_total_payments() - @plan1   # Basic plan
    @plan1_cost = PaymentService.get_plan_payments(1)

    @addon1 = PaymentService.count_addon_payments(1)
    @addon2 = PaymentService.count_addon_payments(2)
    @addon3 = PaymentService.count_addon_payments(3)

    @addon1_cost = PaymentService.get_addon_payments(1)
    @addon2_cost = PaymentService.get_addon_payments(2)
    @addon3_cost = PaymentService.get_addon_payments(3)

    render partial: 'admin/analytics_payment',
           :locals => {
               :plan0 => @plan0,
               :plan1 => @plan1,
               :plan1_cost => @plan1_cost,
               :addon1 => @addon1,
               :addon2 => @addon2,
               :addon3 => @addon3,
               :addon1_cost => @addon1_cost,
               :addon2_cost => @addon2_cost,
               :addon3_cost => @addon3_cost
           }
  end

end