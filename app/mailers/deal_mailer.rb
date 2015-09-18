class DealMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def deal_email(user, deal, email)
    @user = user
    @deal = deal
    @url = "http://localhost:3000/deals"
    @pdf = "http://localhost:3000/deals/" + @deal.id.to_s + ".pdf"
    mail(to: email, subject: "Congratulations! You have successfully listed a deal on Burpple!")
  end

  def update_deal_email(user, deal, email)
    @user = user
    @deal = deal
    @url = "http://localhost:3000/deals"
    @pdf = "http://localhost:3000/deals/" + @deal.id.to_s + ".pdf"
    mail(to: email, subject: "Your deal has been successfully updated!")
  end
end
