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
    assert_difference('merchant.reload.venues.count', +1) do     # assert merchant has 1 more venue
      assert venue.save       # assert venue is saved
    end
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

  test "edit venue" do
    # create venue
    merchant = merchant_one
    merchant.save
    venue = save_venue_one

    # edit venue
    name = "Chicken Down"
    venue.update(name: name)
    assert_equal "Chicken Down", venue.name
  end

  test "delete venue" do
    # create venue
    merchant = merchant_one
    merchant.save
    venue = save_venue_one

    # delete venue
    assert_difference('Venue.count', -1) do
      venue.destroy
    end
  end

  test "view venue" do
    # create venue id 9999
    merchant = merchant_one
    merchant.save
    save_venue_one

    # check venue id 9999 exists
    venue = Venue.find(9999)
    assert_not_nil venue
  end


  private
  def save_venue_one()
    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save
    venue
  end
end
