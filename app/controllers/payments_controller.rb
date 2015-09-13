class PaymentsController < ApplicationController

  def new
    @payment = Payment.new
    @plan = Plan.all
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def index
    @payment = Payment.all
  end

  def create
    #for database
    @payment = Payment.new(payment_params)

    if @payment.save
      redirect_to @payment
      # Send out confirmation email
      # DealMailer.deal_email("Test Food Merchant", @deal).deliver
    else
      render 'new'
    end
  end

  def update
  end

  def show
    @payment = Payment.find(params[:id])
  end

  def destroy
  end

  private
  def payment_params
    params.require(:payment).permit(:plan_1)
  end


end
