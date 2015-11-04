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

  end


  def edit
    @payment = Payment.find(params[:id])
    @plan = Plan.all
    @plan1 = Plan.find(1)
    @addon1 = AddOn.find(1)
    @addon2 = AddOn.find(2)
    @addon3 = AddOn.find(3)
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


    @plan_payment = @payment.plan_payments.new
    if (params[:payment][:plan1] == "true")
      @payment.plan_payments.build(:plan_id => 1)
    end

    if PaymentService.extend_plan(@payment)
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
    if @payment.update(payment_params)
      flash[:success] = "Payment successfully updated!"
      redirect_to payments_extend_plan_path
    else
      flash[:error] = "Failed to update payment!"
      render 'new'
    end
  end

  #when you try to modify a plan
  def extend_plan
    @payment = Payment.find(params[:id])

    #if the merchant is extending the number of months
    if payment_params[:months] != nil
      #if the plan periods overlap
      cost_to_pay = (calculate_price(@payment) * payment_params[:months].to_i)

      if PaymentService.get_overlapping_dates(merchant_id, @payment.start_date, @payment.expiry_date, payment_params[:months].to_i) != 0
        @payment.errors.add(:base, 'Extension of plan clashes with other existing plans')
        @plan = Plan.all
        @plan1 = Plan.find(1)
        @addon1 = AddOn.find(1)
        @addon2 = AddOn.find(2)
        @addon3 = AddOn.find(3)
        render 'edit'

      else #else proceed with payment
        @payment.update(total_cost: cost_to_pay, months: @payment.months + payment_params[:months].to_i)
        redirect_to new_payment_charge_path(@payment)

      end
      #else it is a plan upgrade with addons
    else
      cost_before = calculate_price(@payment) * @payment.months
      @payment.update(payment_params)
      cost_after = (calculate_price(@payment) * @payment.months)
      cost_to_pay = cost_after - cost_before
      @payment.update(total_cost: cost_to_pay)

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
      redirect_to new_payment_charge_path(@payment)
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

  def date_diff(date1,date2)
    (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
  end

  private
  def payment_params
    params.require(:payment).permit(:start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1, :paid, :months)
  end


end
