ActiveAdmin.register Payment do
  actions :all, except: [:edit] # forbid edit to payment information

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

  # SHOW
  show do |f|
    panel "Payment Details" do
      attributes_table_for f do
        row :id
        row :plan do |payment|
          payment.plan
        end
        row :addons do |payment|
          payment.add_ons.map{|a| a.name }.join(", ").html_safe
        end
        row :start_date, label: "Subscription Date"
        row :expiry_date, label: "Expired Date"
        row('Total Paid') do |payment|
          number_to_currency payment.total_cost
        end
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments # Add this line for comment block
  end

end
