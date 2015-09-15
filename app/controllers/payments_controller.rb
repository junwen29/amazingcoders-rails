class PaymentsController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  before_action :set_payment, only: [:show]
 # before_action :show, only: [:calculate_price]

  def new
    @payment = Payment.new
    @plan = Plan.all
   # @add_on = Add_on.all
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def index
    @payments = Payment.where(:merchant_id => merchant_id)
  end

  def create
    #for database
    @payment = Merchant.find(merchant_id).payments.new(payment_params)
    #@payment = Payment.new(payment_params)

    if @payment.save
      flash[:success] = "Your plan has been successfully upgraded!"
      redirect_to @payment
      # Send out confirmation email
      # DealMailer.subscription_email("valued merchant", @payment, MerchantService.get_email(merchant_id)).deliver
    else
      flash[:error] = "Failed to upgrade plan!"
      render 'new'
    end
  end

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
    @total_cost = calculate_price(@payment)
    @payment.update(total_cost: @total_cost)
  end

  def destroy
    @payment.destroy
    flash[:success] = "Payment deleted!"
    redirect_to payments_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  private
  def calculate_price (payment)
    total_cost = 0
  # hardcode
    if payment.plan1
      total_cost = total_cost + 30
    end
    if payment.add_on1
      total_cost = total_cost + 5
    end
    if payment.add_on2
      total_cost = total_cost + 5
    end
    if payment.add_on3
      total_cost = total_cost + 5
    end

    total_cost
  end


  private
  def payment_params
    params.require(:payment).permit(:start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1)
  end


end
