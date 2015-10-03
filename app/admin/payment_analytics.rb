ActiveAdmin.register_page "Payment Analytics" do
  menu :parent => "Payment", :priority => 2

  content do
    @plan1 = PaymentService.count_plan_payments(1)
    @plan_all = PaymentService.count_total_payments()
    @plan1_cost = PaymentService.get_plan_payments(1)
    @addon1 = PaymentService.count_addon_payments(1)
    @addon2 = PaymentService.count_addon_payments(2)
    @addon3 = PaymentService.count_addon_payments(3)
    render partial: 'admin/analytics_payment',
           :locals => {
               :plan_all => @plan_all,
               :plan1 => @plan1,
               :plan1_cost => @plan1_cost,
               :addon1 => @addon1,
               :addon2 => @addon2,
               :addon3 => @addon3
           }
  end

end