ActiveAdmin.register Payment do
  # actions :all, except: [:edit] # forbid edit to payment information

  scope :active
  scope :expired

  # preserve_default_filters!
  remove_filter :plan1, :add_on1, :add_on2, :add_on3, :add_on_payments, :plan_payments, :charge, :paid, :created_at, :updated_at

  action_item :only => :show do
    link_to "Back", "/admin/payments"
  end


  # filter :merchant, :collection => proc {(Merchant.all).map{|m| [m.email, m.id]}}
  #filter :plan
  #filter :addons, :collection => AddOn.all.map(&:name)
  #filter :total_cost
  #filter :start_date, label: 'Subscription Date'
  #filter :expiry_date, label: 'Expiry Date'
  #filter :total_cost, label: 'Premium Paid'
  #filter :plan1, label: 'Deal Listing Plan'
  # filter :add_on1, label: 'Push Notification', as: :check_boxes
  #filter :add_on2, label: 'Deal Statistics'
  #filter :add_on3, label: 'Aggregate Trends'
  #filter :created_at
  #filter :updated_at

  index do |payment|
    selectable_column
    column "Id", :id
    column "Merchant", :merchant_id do |payment|
      auto_link payment.merchant
    end
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
    column "Start Date", :start_date
    column "Expiry Date", :expiry_date
    actions
  end

  # SHOW
  show do |f|
    panel "Payment Details" do
      attributes_table_for f do
        row :id
        row :merchant do |payment|
          auto_link payment.merchant
        end
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
        row :start_date, label: "Start Date"
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

  # CREATE NEW
  form do |f|
    f.semantic_errors
    f.inputs "Payment Details" do
      f.input :merchant
      f.input :plan1, label: "Deal Listing Plan"
      f.input :add_on1, label: "Push Notification Add On"
      f.input :add_on2, label: "Deal Statistics Add On"
      f.input :add_on3, label: "Aggregate Trends Add On"
      f.input :total_cost, as: :string, :hint => "No need to specify currency - defaulted to SGD $. Input to 2 decimal places. e.g. 10.00"
      f.input :start_date
      f.input :expiry_date
    end
    f.actions
  end

  # Allow edit
  permit_params :start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1, :merchant_id, :created_at, :updated_at

end
