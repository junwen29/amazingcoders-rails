class DealMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def deal_email(user, deal)
    @user = user
    @deal = deal
    @url = "www.example.com"
    mail(to: "woonyong92@gmail.com", subject: "Congratulations! You have successfully listed a deal on Burpple!")
  end
end
