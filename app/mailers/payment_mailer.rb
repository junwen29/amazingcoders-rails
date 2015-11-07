class PaymentMailer < ActionMailer::Base
  default from: "noreplyburpple@gmail.com"

  def subscription_email(user, payment, email)
    @user = user
    @payment = payment
    @url = payments_path
    mail(to: email, subject: "You have subscribed to a premium service with Burpple!")
  end

  def update_subscription_admin(user, payment, email)
    @user = user
    @payment = payment
    @url = payments_path
    mail(to: email, subject: "Your Burpple subscription has been updated!")
  end

end
