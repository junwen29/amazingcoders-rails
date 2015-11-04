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

    overall_plan = (PaymentService.count_plan_payments(1).to_f / PaymentService.count_total_payments )*100
    active_plan = (PaymentService.count_active_premiums(Date.today, 1).to_f  / PaymentService.count_total_payments )*100
    @plan_hint = overall_plan.round(1).to_s + "% of Food Merchants have used Premium Deals Services and " + active_plan.round(1).to_s + "% of Food Merchants are currently using it."

    overall_addon1 = (PaymentService.count_unique_addon_payments(1).to_f / PaymentService.count_total_payments)*100
    active_addon1 = (PaymentService.count_active_addons(Date.today, 1).to_f / PaymentService.count_active_premiums(Date.today, 1))*100
    @addon1_hint1 = overall_addon1.round(1).to_s + "% of Food Merchants have used " + @addon1.name + " and " + active_addon1.round(1).to_s + "% of Food Merchants are currently using it."

    addon_1_with_2 = ((PaymentService.count_addons_cross_sell(true, true, false).to_f / Payment.count)*100).round(1)
    addon_1_with_3 = ((PaymentService.count_addons_cross_sell(true, false, true).to_f / Payment.count)*100).round(1)
    @addon1_hint2 = "Food Merchants purchase " + @addon1.name + " with " + @addon2.name + " " + addon_1_with_2.round(1).to_s + "% of the time. " + "Food Merchants purchase " + @addon1.name + " with " + @addon3.name + " " + addon_1_with_3.round(1).to_s + "% of the time. "

    overall_addon2 = (PaymentService.count_unique_addon_payments(2).to_f / PaymentService.count_total_payments)*100
    active_addon2 = (PaymentService.count_active_addons(Date.today, 2).to_f / PaymentService.count_active_premiums(Date.today, 1))*100
    @addon2_hint1 = overall_addon2.round(1).to_s + "% of Food Merchants have used " + @addon2.name + " and " + active_addon2.round(1).to_s + "% of Food Merchants are currently using it."

    addon_2_with_3 = ((PaymentService.count_addons_cross_sell(false, true, true).to_f / Payment.count)*100).round(1)
    @addon2_hint2 = "Food Merchants purchase " + @addon2.name + " with " + @addon1.name + " " + addon_1_with_2.round(1).to_s + "% of the time. " + "Food Merchants purchase " + @addon2.name + " with " + @addon3.name + " " + addon_2_with_3.round(1).to_s + "% of the time. "

    overall_addon3 = (PaymentService.count_unique_addon_payments(3).to_f / PaymentService.count_total_payments)*100
    active_addon3 = (PaymentService.count_active_addons(Date.today, 3).to_f / PaymentService.count_active_premiums(Date.today, 1))*100
    @addon3_hint1 = overall_addon3.round(1).to_s + "% of Food Merchants have used " + @addon3.name + " and " + active_addon3.round(1).to_s + "% of Food Merchants are currently using it."

    @addon3_hint2 = "Food Merchants purchase " + @addon3.name + " with " + @addon1.name + " " + addon_1_with_3.round(1).to_s + "% of the time. " + "Food Merchants purchase " + @addon3.name + " with " + @addon2.name + " " + addon_2_with_3.round(1).to_s + "% of the time. "
  end

  # Disable
=begin
  def edit
    @payment = Payment.find(params[:id])
  end
=end

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
    @plan1 = Plan.find(1)


    @total_cost = calculate_price(@payment)
    @payment.update(total_cost: @total_cost*@payment.months)


    # Update join table in addon_payment
    @add_on_payment = @payment.add_on_payments.build
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
    @plan_payment = @payment.plan_payments.new
    if (params[:payment][:plan1] == "true")
      @payment.plan_payments.build(:plan_id => 1)
    end

    if @payment.save
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
    #upcoming payment includes current payment as well
  end

  def extend
    @payment = Merchant.find(merchant_id).payments.new(payment_params)
    @plan1 = Plan.find(1)

    if PaymentService.extend_plan(@payment)

      @plan_payment = @payment.plan_payments.new
      if (params[:payment][:plan1] == "true")
        @payment.plan_payments.build(:plan_id => 1)
      end

      @add_on_payment = @payment.add_on_payments.build
      @payment.add_on_payments.build(:add_on_id => 1)
      @payment.add_on_payments.build(:add_on_id => 2)
      @payment.add_on_payments.build(:add_on_id => 3)


      @payment.update(expiry_date: @payment.start_date.months_since(1))
      MerchantPointService.create_extend_point(merchant_id)
      flash[:success] = "Gift Redeemed!"
      gift = Gift.find_by name: "1 free month"
      #send acknowledgement email for successful redemption of 1 free month
      #GiftMailer.free_1_month_email("Valued Merchant", @payment, Merchant.find(merchant_id), gift, MerchantService.get_email(merchant_id)).deliver

      redirect_to merchant_points_path
    else
      @upcoming_payments = Payment.where("merchant_id = ? AND paid = ? AND expiry_date >= ?", session[:merchant_id], true, Date.today)
      render 'gift_extend'
    end

  end

  def update
    if payment.update(payment_params)
      flash[:success] = "Payment successfully updated!"
      redirect_to @payment
    else
      flash[:error] = "Failed to update payment!"
      render 'new'
    end
  end



  def destroy
    @payment.destroy
    flash[:success] = "Payment deleted!"
    redirect_to payments_path
  end


=begin
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
  #  @payment = Payment.find(params[:id])
  end
=end

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
