class DealMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def deal_email(user, deal, email)
    @user = user
    @deal = deal
    @url = "https://amazingcodersrails.herokuapp.com/deals"
    @pdf = "https://amazingcodersrails.herokuapp.com/deals/" + @deal.id.to_s + ".pdf"
    mail(to: email, subject: "Congratulations! You have successfully listed a deal on Burpple!")
  end

  def update_deal_email(user, deal, email)
    @user = user
    @deal = deal
    @url = "https://amazingcodersrails.herokuapp.com/deals"
    @pdf = "https://amazingcodersrails.herokuapp.com/deals/" + @deal.id.to_s + ".pdf"
    mail(to: email, subject: "Your deal has been successfully updated!")
  end

  def update_deal_email_admin(user, deal, email)
    @user = user
    @deal = deal
    @url = "https://amazingcodersrails.herokuapp.com/deals"
    @pdf = "https://amazingcodersrails.herokuapp.com/deals/" + @deal.id.to_s + ".pdf"
    mail(to: email, subject: "Your deal has been successfully updated!")
  end
end
