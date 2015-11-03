class Notification < ActiveRecord::Base
  belongs_to :user

  include Notification::Json
end
