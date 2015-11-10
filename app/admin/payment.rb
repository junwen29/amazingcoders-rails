ActiveAdmin.register Payment do
  # actions :all, except: [:edit] # forbid edit to payment information
  config.clear_action_items!
  config.sort_order = "created_at_desc"

  menu :parent => "Payment", :priority => 1

  controller do
    def scoped_collection
      Payment.where(paid: true)
    end

    def update
      @payment = Payment.find(params[:id])
      if @payment.update_columns(payment_params)
        flash[:success] = "Payment successfully updated!"
        merchant_id = @payment.merchant_id
        PaymentMailer.update_subscription_admin("valued merchant", @payment, MerchantService.get_email(merchant_id)).deliver
        redirect_to admin_payment_path
      else
        flash[:error] = "Failed to update payment!"
      end
    end

    private
    def payment_params
      params.require(:payment).permit(:start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1, :paid, :months)
    end

  end

  scope :all
  scope :active
  scope :expired
  scope :future
  scope :dashboard do |payments|
    date = Date.today.end_of_month
    plan_id = 1
    all_premiums = payments.where('start_date <= ? AND expiry_date >= ? AND paid = ?', date, date, true)
    plan_premiums = all_premiums.joins(:plan_payments).where('plan_payments.plan_id' => plan_id)
  end

  # preserve_default_filters!
  remove_filter :plan1, :add_on1, :add_on2, :add_on3, :add_on_payments, :plan_payments, :charge, :paid, :created_at, :updated_at

  action_item :only => :show do
    link_to "Back", "/admin/payments"
  end

  index do
    selectable_column
    column "Id", :id
    column "Merchant", :merchant_id do |payment|
      auto_link payment.merchant
    end
    column "Plan" do |payment|
      #auto_link payment.plans
      if payment.plan1
        plan = Plan.find(1)
        auto_link plan
      else
        payment.plans.map{|p| p.name }.join(", ").html_safe
      end
    end
    column "Add Ons" do |payment|
      payment.add_ons.map{|a| a.name }.join(", ").html_safe
    end
    column "Premium Paid", sortable: 'total_cost' do |payment|
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
          else
            payment.plans.map{|p| p.name }.join(", ").html_safe
          end
        end
        row :addons do |payment|
          payment.add_ons.map{|a| a.name }.join(", ").html_safe
        end
        row :start_date
        row :expiry_date
        row('Total Paid') do |payment|
          number_to_currency payment.total_cost
        end
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments # Add this line for comment block
  end

  # EDIT
  form do |f|
    f.semantic_errors
    f.inputs "Payment Details" do
      f.input :merchant
      f.input :plan1, label: "Deal Listing Plan"
      f.input :add_on1, label: "Push Notification Add On"
      f.input :add_on2, label: "Deal Statistics Add On"
      f.input :add_on3, label: "Aggregate Trends Add On"
      f.input :total_cost, as: :string, :hint => "No need to specify currency - defaulted to SGD $. Input to 2 decimal places. e.g. 10.00"
    end
    f.actions
  end

  # Allow edit
  permit_params :start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1, :merchant_id, :created_at, :updated_at

end
