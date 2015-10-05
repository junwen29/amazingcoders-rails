class Merchant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :venues, dependent: :destroy
  has_many :deals
  has_many :payments
  has_many :feedbacks

  def display_name
    self.email # or whatever column you want
  end

end
