ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.gmail.com',
    :domain         => 'burpple.com',
    :port           => 587,
    :user_name      => 'noreplyburpple@gmail.com',
    :password       => 'burppleadmin',
    :authentication => :plain,
    :enable_starttls_auto => true
}

# TODO: Remove this interceptor for actual demonstration
#if Rails.env.development?
    #ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
#end