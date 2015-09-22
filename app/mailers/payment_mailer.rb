class PaymentMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def subscription_email(user, payment, email)
    @user = user
    @payment = payment
    @url = payments_path
    mail(to: email, subject: "You have subscribed to a premium service with Burpple!")
  end

end
