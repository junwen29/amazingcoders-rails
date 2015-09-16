class PaymentsController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  before_action :set_payment, only: [:show]
 # before_action :show, only: [:calculate_price]

  def new
    @payment = Payment.new
    @plan = Plan.all
    # Update join table
    @add_on_payment = @payment.add_on_payments.build
  end

  # Disable
=begin
  def edit
    @payment = Payment.find(params[:id])
  end
=end

  def index
    @payments = Payment.where(:merchant_id => merchant_id)
    @current_payment = Payment.where("merchant_id = ? AND start_date <= ? AND expiry_date >= ?", merchant_id, Date.today, Date.today).last
  end

  def create
    #for database
    @payment = Merchant.find(merchant_id).payments.new(payment_params)
    #@payment = Payment.new(payment_params)
    @total_cost = calculate_price(@payment)
    @payment.update(total_cost: @total_cost)

    # Update join table
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

    if @payment.save
      flash[:success] = "Your plan has been successfully upgraded!"
      redirect_to @payment
      # Send out confirmation email
      #PaymentMailer.subscription_email("valued merchant", @payment, MerchantService.get_email(merchant_id)).deliver
    else
      flash[:error] = "Failed to upgrade plan!"
      render 'new'
    end
  end

  # Disable
=begin
  def update
    if payment.update(payment_params)
      flash[:success] = "Payment successfully updated!"
      redirect_to @venue
    else
      flash[:error] = "Failed to update payment!"
      render 'new'
    end
  end

  def show
    @payment = Payment.find(params[:id])
  end

  def destroy
    @payment.destroy
    flash[:success] = "Payment deleted!"
    redirect_to payments_path
  end
=end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
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
      total_cost = total_cost + add_on1_cost
    end
    if payment.add_on3
      total_cost = total_cost + add_on1_cost
    end

    total_cost
  end


  private
  def payment_params
    params.require(:payment).permit(:start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1)
  end


end
