require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

  #========================== test positive ========================

  test "save device" do
    device = Device.new(:user_id => "999",:token =>"DeviceTest", :device_type => "android_gcm")
    assert device.save
  end

  #=========================== test negative ========================
  test "should not save device without device type" do
    device = Device.new
    assert_no device.save
  end

  test "should not save device if token is not unique to user" do
    device_one = Device.new(:user_id => "1", :token => "token", :device_type => "android_type")
    assert device_one.save
    device_two = Device.new(:user_id => "1", :token => "token", :device_type => "android_type")
    assert_no device_two.save
  end

end
