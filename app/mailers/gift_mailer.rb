class GiftMailer < ActionMailer::Base
  default from: "noreplyburpple@gmail.com"

  def gift_email(user, merchant, gift, email)
    @user = user
    @gift = gift
    @points_left = merchant.total_points
    @url = "https://amazingcodersrails.herokuapp.com" + gifts_path
    mail(to: email, subject: "You have redeemed a gift at Burpple!")
  end

  def free_1_month_email(user, payment, merchant, gift, email)
    @user = user
    @payment = payment
    @url = gifts_path
    @points_left = merchant.total_points
    @gift = gift
    mail(to: email, subject: "You have redeemed a gift at Burpple!")
  end

  # Users
  def user_gift_email(user, gift)
    @username = user.username
    @points_left = user.total_points
    @gift = gift
    email = user.email
    mail(to: email, subject: "You have redeemed a gift at Burpple!")
  end

end
