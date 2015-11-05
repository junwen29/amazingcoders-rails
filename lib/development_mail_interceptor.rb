class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.to = ['burpple@mail.com']
  end
end