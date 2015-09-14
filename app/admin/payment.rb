ActiveAdmin.register Payment do

  index do
    selectable_column
    column "Id", :id
=begin
    column "Merchant", :merchant_id do |payment|
      auto_link payment.merchant
    end
=end
    column "Plan" do |payment|
      auto_link payment.plan
    end
    column "Add Ons" do |payment|
      payment.add_ons.map{|a| a.name }.join(", ").html_safe
    end
    column "Premium Paid", :total_cost do |payment|
      number_to_currency payment.total_cost
    end
    column "Subscription Date", :start_date
    column "Expiry Date", :expiry_date
    actions
  end


end
