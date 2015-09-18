class PaymentsController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  before_action :set_payment, only: [:show]
 # before_action :show, only: [:calculate_price]
  #after_create :last_step

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
    @current_payment = Payment.where("merchant_id = ? AND start_date <= ? AND expiry_date >= ?", merchant_id, Date.today, Date.today).last
  end

  def create
    #for database
   @payment = Merchant.find(merchant_id).payments.new(payment_params)
    # @payment = Payment.new(payment_params)



    @total_cost = calculate_price(@payment)
    @payment.update(total_cost: @total_cost)

    #if token is created successfully, go to show page and check if charge is created.
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
   # @payment = Payment.find(params[:id])

    #stripe sample code
    customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @total_cost,
        :source  => params[:stripeToken],
        :description => 'Plan Upgrade',
        :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    # redirect_to charges_path

    if payment.update(payment_params)
      flash[:success] = "Payment successfully updated!"
      redirect_to @venue
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
 #   @payment = Payment.find(params[:id])
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

  def last_step
    @payment.save if @video.save_with_payment(@total_cost)
  end

  private
  def payment_params
    params.require(:payment).permit(:start_date, :expiry_date, :total_cost, :add_on1, :add_on2, :add_on3, :plan1)
  end


end
