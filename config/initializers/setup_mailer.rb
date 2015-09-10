ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.mail.com',
    :domain         => 'mail.com',
    :port           => 587,
    :user_name      => 'burpple@mail.com',
    :password       => 'qwerty123',
    :authentication => :plain,
    :enable_starttls_auto => true
}