require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  test "save venue" do
    merchant = merchant_one
    merchant.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    assert venue.save
  end

  test "should not save venue without name" do
    merchant = merchant_one
    merchant.save

    name = nil
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    assert_not venue.save
  end

  test "should not save venue without street" do
    merchant = merchant_one
    merchant.save

    name = "Chicken Up @ Tampines"
    street = nil
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    assert_not venue.save
  end

  test "should not save venue without zipcode" do
    merchant = merchant_one
    merchant.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = nil
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    assert_not venue.save
  end

  test "should not save venue without neighbourhood" do
    merchant = merchant_one
    merchant.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = nil
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    assert_not venue.save
  end

  test "should not save venue without phone" do
    merchant = merchant_one
    merchant.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = nil
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    assert_not venue.save
  end
end
