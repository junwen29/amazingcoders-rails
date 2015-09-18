class ChargesController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  def new
   # @payment = Payment.find(:id)
  end

  def create
    # Amount in cents


    customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => '100',
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path

    redirect_to payments_path
  end



end
