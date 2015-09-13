class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show]

  def new
    @payment = Payment.new
    @plan = Plan.all
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

  def show
    @payment = Payment.find(params[:id])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  private
  def payment_params
    params.require(:payment).permit(:plan1, :add_on1, :add_on2, :add_on3, :start_date, :expiry_date )
  end


end
