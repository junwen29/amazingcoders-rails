class User < ActiveRecord::Base

  include User::Json
  include User::Authentication

  has_many :wishes, inverse_of: :venue, dependent: :destroy
  has_many :venues, through: :wishes
  has_many :devices, :dependent => :destroy
  has_many :bookmarks, inverse_of: :deal, dependent: :destroy
  has_many :deals, through: :bookmarks
  has_many :redemptions
  has_many :viewcounts
  has_many :user_feedbacks, inverse_of: :user
  has_many :user_points, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validation rule
  validates :first_name, :presence => true, :length => {:maximum => 255}
  validates :last_name, :presence => true, :length => {:maximum => 255}
  validate :username_valid, if: :username_changed?
  validates_uniqueness_of :username, allow_blank: true, allow_nil: true, case_sensitive: false, message: "%{value} is already taken", if: :username_changed?
  validates_uniqueness_of :email, allow_blank: false, allow_nil: false, case_sensitive: true, message: "%{value} is already taken", if: :email_changed?

  def username_valid
    return if username.nil?
    return errors.add(:username, "can't be blank") if username.blank?

    # quick fix for username space error
    self.username = self.username.strip

    valid_characters = "[a-zA-Z_\-]"
    all_numbers = (username =~ Regexp.new('^(?=.*[' + valid_characters + '])')).nil?
    return errors.add(:username, "can't be all numbers") if all_numbers
    invalid_characters = (username =~ Regexp.new('^[' + valid_characters + '0-9]+$')).nil?
    return errors.add(:username, 'can only contain letters, numbers, and underscore') if invalid_characters
  end


  # def skip_confirmation!
  #   self.confirmed_at = Time.now
  # end
end