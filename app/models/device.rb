#--
# Device model is the class to keep device token of android
#++
class Device < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :token, :scope => :user_id
  validates :device_type, :inclusion => { :in => ['ios','iphone','android','android_gcm'] }

  def self.save(user, token, device_type)
    device = Device.where(:user_id => user.id, :token => token, :device_type => device_type).first
    unless device
      device = Device.new
      device.user    = user
      device.token   = token
      device.device_type = device_type
      device.save
    end
    return device
  end

  ##if user doesn't specify any token, types, then delete all
  def self.destroy(user, token = nil, device_type = nil)
    if token and device_type
      devices = Device.where(:user_id => user.id, :token => token, :device_type => device_type)
    elsif token
      devices = Device.where(:user_id => user.id, :token => token)
    elsif device_type
      devices = Device.where(:user_id => user.id, :device_type => device_type)
    else
      devices = Device.where(:user_id => user.id)
    end
    devices.destroy_all
  end
end
