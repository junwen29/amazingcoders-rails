class ChargesController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]

  def new
    @payment = Payment.find(params[:payment_id])
    #total_cost = @payment.total_cost
    @payment.update(expiry_date: @payment.start_date.months_since(@payment.months))
  end

  def create
    # Amount in cents
    @payment = Payment.find(params[:payment_id])

    customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @payment.total_cost.to_i*100,
        :description => 'Rails Stripe customer',
        :currency    => 'sgd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path

  redirect_to payment_path(@payment.id)
  end




end
