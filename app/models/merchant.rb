class Merchant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :venues, dependent: :destroy
  has_many :deals, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :merchant_points, dependent: :destroy
  has_many :merchant_feedbacks, dependent: :destroy

  def display_name
    self.email # or whatever column you want
  end

end
