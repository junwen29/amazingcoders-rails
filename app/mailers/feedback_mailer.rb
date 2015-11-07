class FeedbackMailer < ActionMailer::Base
  default from: "noreplyburpple@gmail.com"

  # Merchants
  def merchant_feedback_email(email, feedback)
    @feedback = feedback
    @url = "https://amazingcodersrails.herokuapp.com" + merchant_feedbacks_path
    mail(to: email, subject: "Thank you for your feedback!")
  end

  # Users
  def user_feedback_email(user, feedback)
    @username = user.username
    @feedback = feedback
    email = user.email
    mail(to: email, subject: "Thank you for your feedback!")
  end

end
