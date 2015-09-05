class DealMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def deal_email(user, deal)
    @user = user
    @deal_type = deal.type_of_deal
    @deal_start = deal.start_date
    @deal_end = deal.expiry_date
    @deal_location = deal.location
    @deal_multiple = deal.multiple_use
    @deal_redeemable = deal.redeemable
    @url = "www.example.com"
    mail(to: "jkcheong92@gmail.com", subject: "Congratulations! You have successfully listed a deal on Burpple!")
  end
end
