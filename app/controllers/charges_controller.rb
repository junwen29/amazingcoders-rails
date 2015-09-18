class ChargesController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]
  def new
    @payment
  end

  def create
    # Amount in cents
    @amount = @payment.total_cost

    customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path

  end


end
