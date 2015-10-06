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
    begin
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
        # Send out payment acknowledgement email
        # PaymentMailer.subscription_email("valued merchant", @payment, MerchantService.get_email(merchant_id)).deliver

    rescue Stripe::CardError => e
      flash[:error] = e.message
    end

    @merchant = Merchant.find(merchant_id)
    total_points = @merchant.total_points
    total_points += @payment.total_cost

    payments = Payment.where(merchant_id: merchant_id, paid: true)
    total_months = 0
    payments.each do |p|
      total_months += p.months
    end

    flash[:success] = "Plan upgrade completed! You have been awarded " + @payment.total_cost.to_i.to_s + " Burps!"
    @payment.update(paid: true)

    #if milestone of 12 months is cleared, add 500 to total points
    if ((((total_months.to_i + @payment.months.to_i)/12) - (total_months.to_i/12)) != 0)
      total_points += 500
      flash[:success] = "Plan upgrade completed! You have been awarded " + @payment.total_cost.to_i.to_s + " Burps! Thanks for being a loyal user! You have been credited an extra 500 Burps!"
    end

    @merchant.update(total_points: total_points)
    redirect_to payment_path(@payment.id)

  end
end
