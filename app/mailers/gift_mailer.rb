class GiftMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def gift_email(user, merchant, gift, email)
    @user = user
    @gift = gift
    @points_left = merchant.total_points
    @url = gifts_path
    mail(to: email, subject: "You have redeemed a gift at Burpple!")
  end

  def free_1_month_email(user, payment, merchant, gift, email)
    @user = user
    @payment = payment
    @url = payments_path
    @points_left = merchant.total_points
    @gift = gift
    mail(to: email, subject: "Your Burpple subscription has been updated!")
  end

end
