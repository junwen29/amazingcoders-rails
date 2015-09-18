class Payment < ActiveRecord::Base
  has_one :plan
  has_many :add_ons
  belongs_to :merchant
  
  scope :active, -> {where("start_date <= ? AND expiry_date >= ?", Date.today, Date.today)}
  scope :expired, -> {where("expiry_date < ?", Date.today)}

  def save_with_payment(total_cost)
    if valid?
      #stripe sample code
      dollars = total_cost*100
      customer = Stripe::Customer.create(
          :email => 'example@stripe.com',
          :card  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => dollars,
          :source  => params[:stripeToken],
          :description => 'Plan Upgrade',
          :currency    => 'usd'
      )
    end
  end

end