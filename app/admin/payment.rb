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
      # auto_link payment.plan
      if (payment.plan1)
        plan = Plan.find(1)
        auto_link plan
      end
    end
    column "Add Ons" do |payment|
      # payment.add_ons.map{|a| a.name }.join(", ").html_safe
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
          #payment.plan
          if (payment.plan1)
            plan = Plan.find(1)
            auto_link plan
          end
        end
        row :addons do |payment|
          #payment.add_ons.map{|a| a.name }.join(", ").html_safe
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
