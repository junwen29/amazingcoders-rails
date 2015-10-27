class GiftMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def gift_email(user, merchant, gift, email)
    @user = user
    @gift_points = gift.points
    @gift_name = gift.name
    @points_left = merchant.total_points
    @url = gifts_path
    mail(to: email, subject: "You have redeemed a gift at Burpple!")
  end

  def extend_email(user, payment, email)
    @user = user
    @payment = payment
    @url = payments_path
    mail(to: email, subject: "Your Burpple subscription has been updated!")
  end

end
