#--
#this module is for method related to authentication
#++

module User::Authentication
  extend ActiveSupport::Concern

  included do
    before_validation :bypass_password_confirmation, :on => :create

    # for Devise
    # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
    before_save :ensure_authentication_token
    def ensure_authentication_token
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    private

    def bypass_password_confirmation
      self.password_confirmation ||= self.password
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

  end # / included
end
