class PaymentsController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  # before_action :set_payment, only: [:show]
  # before_action :show, only: [:calculate_price]

  def new
    @payment = Payment.new
    @plan = Plan.all
    @plan1 = Plan.find(1)
    @addon1 = AddOn.find(1)
    @addon2 = AddOn.find(2)
    @addon3 = AddOn.find(3)

    #active_premiums = PaymentService.count_active_payments(Date.today)
    hint_messages = get_hint_messages
    @plan_hint = hint_messages[0]
    @addon1_hint1 = hint_messages[1]
    @addon1_hint2 = hint_messages[2]
    @addon2_hint1 = hint_messages[3]
    @addon2_hint2 = hint_messages[4]
    @addon3_hint1 = hint_messages[5]
    @addon3_hint2 = hint_messages[6]

  end


  def edit
    @payment = Payment.find(params[:id])
    unless session[:merchant_id] == @payment.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to payments_path
      return
    end
    @plan = Plan.all
    @plan1 = Plan.find(1)
    @addon1 = AddOn.find(1)
    @addon2 = AddOn.find(2)
    @addon3 = AddOn.find(3)

    hint_messages = get_hint_messages
    @plan_hint = hint_messages[0]
    @addon1_hint1 = hint_messages[1]
    @addon1_hint2 = hint_messages[2]
    @addon2_hint1 = hint_messages[3]
    @addon2_hint2 = hint_messages[4]
    @addon3_hint1 = hint_messages[5]
    @addon3_hint2 = hint_messages[6]

  end

  def get_hint_messages
    total_payments = PaymentService.count_total_payments

    overall_plan = ((PaymentService.count_plan_payments(1).to_f / total_payments )*100).round(1)
    active_plan = ((PaymentService.count_active_premiums(Date.today, 1).to_f / total_payments )*100).round(1)
    @plan_hint = overall_plan.round(1).to_s + "% of Food Merchants have used Premium Deals Services and " + active_plan.round(1).to_s + "% of Food Merchants are currently using it."

    overall_addon1 = (PaymentService.count_unique_addon_payments(1).to_f / total_payments)*100
    active_addon1 = (PaymentService.count_active_addons(Date.today, 1).to_f / total_payments)*100
    @addon1_hint1 = overall_addon1.round(1).to_s + "% of Food Merchants have used " + @addon1.name + " and " + active_addon1.round(1).to_s + "% of Food Merchants are currently using it."

    addon_1_with_2 = ((PaymentService.count_addons_cross_sell(true, true, false).to_f / Payment.count)*100).round(1)
    addon_1_with_3 = ((PaymentService.count_addons_cross_sell(true, false, true).to_f / Payment.count)*100).round(1)
    @addon1_hint2 = "Food Merchants purchased " + @addon1.name + " with " + @addon2.name + " " + addon_1_with_2.round(1).to_s + "% of the time. " + "Food Merchants purchased " + @addon1.name + " with " + @addon3.name + " " + addon_1_with_3.round(1).to_s + "% of the time. "

    overall_addon2 = (PaymentService.count_unique_addon_payments(2).to_f / total_payments)*100
    active_addon2 = (PaymentService.count_active_addons(Date.today, 2).to_f / total_payments)*100
    @addon2_hint1 = overall_addon2.round(1).to_s + "% of Food Merchants have used " + @addon2.name + " and " + active_addon2.round(1).to_s + "% of Food Merchants are currently using it."

    addon_2_with_3 = ((PaymentService.count_addons_cross_sell(false, true, true).to_f / Payment.count)*100).round(1)
    @addon2_hint2 = "Food Merchants purchased " + @addon2.name + " with " + @addon1.name + " " + addon_1_with_2.round(1).to_s + "% of the time. " + "Food Merchants purchased " + @addon2.name + " with " + @addon3.name + " " + addon_2_with_3.round(1).to_s + "% of the time. "

    overall_addon3 = (PaymentService.count_unique_addon_payments(3).to_f / total_payments)*100
    active_addon3 = (PaymentService.count_active_addons(Date.today, 3).to_f / total_payments)*100
    @addon3_hint1 = overall_addon3.round(1).to_s + "% of Food Merchants have used " + @addon3.name + " and " + active_addon3.round(1).to_s + "% of Food Merchants are currently using it."

    @addon3_hint2 = "Food Merchants purchased " + @addon3.name + " with " + @addon1.name + " " + addon_1_with_3.round(1).to_s + "% of the time. " + "Food Merchants purchased " + @addon3.name + " with " + @addon2.name + " " + addon_2_with_3.round(1).to_s + "% of the time. "

    [@plan_hint, @addon1_hint1, @addon1_hint2, @addon2_hint1, @addon2_hint2, @addon3_hint1, @addon3_hint2]
  end


  def index
    @payments = Payment.all

    @payments.each do |p|
      if !p.paid
        p.destroy
      end
    end

    @payments = Payment.where(merchant_id: merchant_id, paid: true)
    @current_payment = Payment.where("merchant_id = ? AND paid = ? AND start_date <= ? AND expiry_date >= ?", merchant_id, true, Date.today, Date.today).last

  end

  def create
    #for database
    @payment = Merchant.find(merchant_id).payments.new(payment_params)
   # @plan1 = Plan.find(1)



    if @payment.save
      # Update join table in addon_payment
      @payment.add_on_payments.build
      if (params[:payment][:add_on1] == "true")
        @payment.add_on_payments.build(:add_on_id => 1)
      end
      if (params[:payment][:add_on2] == "true")
        @payment.add_on_payments.build(:add_on_id => 2)
      end
      if (params[:payment][:add_on3] == "true")
        @payment.add_on_payments.build(:add_on_id => 3)
      end

      # Update join table in plan_payment
      @payment.plan_payments.new
      if (params[:payment][:plan1] == "true")
        @payment.plan_payments.build(:plan_id => 1)
      end
      @total_cost = calculate_price(@payment)
      @payment.update(total_cost: @total_cost*@payment.months)
      # flash[:success] = "Success in registering plan"
      redirect_to new_payment_charge_path(@payment.id)
      #if token is created successfully, go to show page and check if charge is created.
    else
      flash[:error] = "Failed to upgrade plan"
      @plan = Plan.all
      @plan1 = Plan.find(1)
      @addon1 = AddOn.find(1)
      @addon2 = AddOn.find(2)
      @addon3 = AddOn.find(3)

      hint_messages = get_hint_messages
      @plan_hint = hint_messages[0]
      @addon1_hint1 = hint_messages[1]
      @addon1_hint2 = hint_messages[2]
      @addon2_hint1 = hint_messages[3]
      @addon2_hint2 = hint_messages[4]
      @addon3_hint1 = hint_messages[5]
      @addon3_hint2 = hint_messages[6]

      render 'new'

    end
  end

  def show
    @payment = Payment.find(params[:id])
    unless session[:merchant_id] == @payment.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to payments_path
      return
    end
  end

  def gift_extend
    @payment = Payment.new
  end

  #for gift redemption of 1 free month
  def extend
    @payment = Merchant.find(merchant_id).payments.new(payment_params)
    @plan1 = Plan.find(1)

    if @payment.start_date == nil
      @payment.errors.add(:base, 'Please fill in the start date')
      @upcoming_payments = Payment.where("merchant_id = ? AND paid = ? AND expiry_date >= ?", session[:merchant_id], true, Date.today)
      render 'gift_extend'
    elsif @payment.start_date < Date.today
      @payment.errors.add(:base, 'Please select a date starting from today onwards')
      @upcoming_payments = Payment.where("merchant_id = ? AND paid = ? AND expiry_date >= ?", session[:merchant_id], true, Date.today)
      render 'gift_extend'
    elsif PaymentService.get_overlapping_payments(merchant_id, @payment.start_date, 1) == 0
      @payment.update(plan1: true, add_on1: true, add_on2: true, add_on3: true, total_cost: 0, months: 1, paid: true,
                      expiry_date: @payment.start_date.months_since(1))

      #@payment.update(paid: true)

      @plan_payment = @payment.plan_payments.new
      if (params[:payment][:plan1] == "true")
        @payment.plan_payments.build(:plan_id => 1)
      end

      @add_on_payment = @payment.add_on_payments.build
      @payment.add_on_payments.build(:add_on_id => 1)
      @payment.add_on_payments.build(:add_on_id => 2)
      @payment.add_on_payments.build(:add_on_id => 3)

      #@payment.update(expiry_date: @payment.start_date.months_since(1))
      MerchantPointService.create_extend_point(merchant_id)
      flash[:success] = "Gift Redeemed!"
      gift = Gift.find_by name: "1 free month"
      #send acknowledgement email for successful redemption of 1 free month
      GiftMailer.free_1_month_email("Valued Merchant", @payment, Merchant.find(merchant_id), gift, MerchantService.get_email(merchant_id)).deliver

      redirect_to merchant_points_path
    else
      @payment.errors.add(:base, 'Extension of plan clashes with other existing plans')
      @upcoming_payments = Payment.where("merchant_id = ? AND paid = ? AND expiry_date >= ?", session[:merchant_id], true, Date.today)
      render 'gift_extend'
    end

  end

  def update
    if @payment.update(payment_params)
      flash[:success] = "Payment successfully updated!"
      redirect_to payments_extend_plan_path
    else
      flash[:error] = "Failed to update payment!"
      render 'new'
    end
  end

  #when you try to modify a plan (either addon upgrade or plan extension)
  def extend_plan
    @payment = Payment.find(params[:id])
    unless session[:merchant_id] == @payment.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to payments_path
      return
    end
    #if the merchant is extending the number of months
    if payment_params[:months] != nil

      #if the plan periods overlap
      if PaymentService.get_overlapping_dates(merchant_id, @payment.expiry_date, payment_params[:months].to_i) != 0
        @payment.errors.add(:base, 'Extension of plan clashes with other existing plans')
        @plan = Plan.all
        @plan1 = Plan.find(1)
        @addon1 = AddOn.find(1)
        @addon2 = AddOn.find(2)
        @addon3 = AddOn.find(3)

        hint_messages = get_hint_messages
        @plan_hint = hint_messages[0]
        @addon1_hint1 = hint_messages[1]
        @addon1_hint2 = hint_messages[2]
        @addon2_hint1 = hint_messages[3]
        @addon2_hint2 = hint_messages[4]
        @addon3_hint1 = hint_messages[5]
        @addon3_hint2 = hint_messages[6]

        render 'edit'

      else #else proceed with payment
        cost_to_pay = (calculate_price(@payment) * payment_params[:months].to_i)
      #  @payment.update(total_cost: cost_to_pay, months: @payment.months + payment_params[:months].to_i)
        @payment_new = Payment.create(start_date: @payment.start_date, expiry_date: @payment.expiry_date, add_on1: @payment.add_on1,
                            add_on2: @payment.add_on2, add_on3: @payment.add_on3, plan1: @payment.plan1,
                            total_cost: cost_to_pay, months: @payment.months + payment_params[:months].to_i, paid: false,
                            id: Payment.last.id+1, merchant_id: merchant_id)
        @payment_new.save(validate: false)

        # Update join table in addon_payment
        if @payment.add_on1
          AddOnPayment.create(id: AddOnPayment.last.id+1, add_on_id: 1, payment_id: Payment.order(id: :asc).last.id)
        end
        if @payment.add_on2
          AddOnPayment.create(id: AddOnPayment.last.id+1, add_on_id: 2, payment_id: Payment.order(id: :asc).last.id)
        end
        if @payment.add_on3
          AddOnPayment.create(id: AddOnPayment.last.id+1, add_on_id: 3, payment_id: Payment.order(id: :asc).last.id)
        end

      # Update join table in plan_payment
        if @payment.plan1
          PlanPayment.create(id: PlanPayment.last.id+1, plan_id: 1, payment_id: Payment.order(id: :asc).last.id)
        end

     #   redirect_to payment_new_modify_path(@payment_new)
        redirect_to new_payment_charge_path(@payment_new)
      end
      #else it is a plan upgrade with addons
    else

=begin
      cost_before = calculate_price(@payment) * @payment.months
      @payment.update(payment_params)

      cost_after = (calculate_price(@payment) * @payment.months)

      cost_to_pay = cost_after - cost_before
      @payment.update(total_cost: cost_to_pay)
      @payment.save
=end

      cost_before = calculate_price(@payment) * @payment.months


      @payment_new = Payment.create(start_date: @payment.start_date, expiry_date: @payment.expiry_date, add_on1: @payment.add_on1,
                                    add_on2: @payment.add_on2, add_on3: @payment.add_on3, plan1: @payment.plan1,
                                    total_cost: @payment.total_cost, months: @payment.months, paid: false,
                                    id: Payment.last.id+1, merchant_id: merchant_id)
      @payment_new.save(validate: false)
      @payment_new.update(payment_params)
      cost_after = (calculate_price(@payment_new) * @payment_new.months)

      cost_to_pay = cost_after - cost_before
      @payment_new.update(total_cost: cost_to_pay)

      # Update join table in addon_payment
      if @payment.add_on1
        AddOnPayment.create(id: AddOnPayment.last.id+1, add_on_id: 1, payment_id: Payment.order(id: :asc).last.id)
      end
      if @payment.add_on2
        AddOnPayment.create(id: AddOnPayment.last.id+1, add_on_id: 2, payment_id: Payment.order(id: :asc).last.id)
      end
      if @payment.add_on3
        AddOnPayment.create(id: AddOnPayment.last.id+1, add_on_id: 3, payment_id: Payment.order(id: :asc).last.id)
      end

      # Update join table in plan_payment
      if @payment.plan1
        PlanPayment.create(id: PlanPayment.last.id+1, plan_id: 1, payment_id: Payment.order(id: :asc).last.id)
      end

      redirect_to new_payment_charge_path(@payment_new)
    end

  end

  def destroy
    @payment.destroy
    flash[:success] = "Payment deleted!"
    redirect_to payments_path
  end

  private
  def calculate_price (payment)
    total_cost = 0
    deal_plan_cost = Plan.find(1).cost      # deal listing plan has id = 1
    add_on1_cost = AddOn.find(1).cost
    add_on2_cost = AddOn.find(2).cost
    add_on3_cost = AddOn.find(3).cost

    if payment.plan1
      total_cost = total_cost + deal_plan_cost
    end
    if payment.add_on1
      total_cost = total_cost + add_on1_cost
    end
    if payment.add_on2
      total_cost = total_cost + add_on2_cost
    end
    if payment.add_on3
      total_cost = total_cost + add_on3_cost
    end
    total_cost
  end

  private
  def payment_params
    params.require(:payment).permit(:start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1, :paid, :months)
  end


end
