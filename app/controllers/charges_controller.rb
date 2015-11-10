class ChargesController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]

  def new
    @payment = Payment.find(params[:payment_id])

    unless session[:merchant_id] == @payment.merchant_id #&& @payment.paid == false
      flash[:error] = "You don't have access to this page!"
      redirect_to payments_path
      return
    end
    #total_cost = @payment.total_cost
    #@payment.update(expiry_date: @payment.start_date.months_since(@payment.months))
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

    MerchantPointService.new_point("Paid for a plan upgrade", @payment.total_cost, "Credit", merchant_id)

    flash[:success] = "Plan upgrade completed! You have been awarded " + @payment.total_cost.to_i.to_s + " Burps!"

    #if milestone of 12 months is cleared, add 500 to total MerchantPoints
    if (((total_months.to_i + @payment.months.to_i)/12) - (total_months.to_i/12)) != 0
      total_points += 500
      MerchantPointService.new_point("12 months milestone reward", 500, "Credit", merchant_id)
      flash[:success] = "Plan upgrade completed! You have been awarded " + @payment.total_cost.to_i.to_s + " Burps! Thanks for being a loyal user! You have been credited an extra 500 Burps!"
    end
    @payment.update(paid: true, total_cost: PaymentService.calculate_price(@payment)*@payment.months, expiry_date: @payment.start_date.months_since(@payment.months))

    old_payment = Payment.where(:merchant_id => merchant_id, :start_date => @payment.start_date)
    old_payment.each do |p|
      if p && (p.id != @payment.id)
        PaymentService.destroy(p)
      end
    end

    @merchant.update(total_points: total_points)

    # Send out payment acknowledgement email
    PaymentMailer.subscription_email("valued merchant", @payment, MerchantService.get_email(merchant_id)).deliver

    redirect_to payments_path

  end

  
end
