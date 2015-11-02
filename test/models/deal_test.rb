require 'test_helper'

class DealTest < ActiveSupport::TestCase
  test "save waiting deal" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today, 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.tomorrow
    end_date = start_date + 1.days
    redeemable = true
    multiple_use = true

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    assert_difference('venue.reload.deals.count', +1) do
      assert deal.save
    end
  end

  test "should not save deal if start date passed" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today, 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.yesterday
    end_date = start_date + 1.days
    redeemable = true
    multiple_use = true

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    assert_not deal.save
  end

  test "should not save if end date is before start date" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today, 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.tomorrow
    end_date = start_date - 1.days
    redeemable = true
    multiple_use = true

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    assert_not deal.save
  end

  test "should not save deal without redeemable" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today, 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.tomorrow
    end_date = start_date + 1.days
    redeemable = nil
    multiple_use = true

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    assert_not deal.save
  end

  test "should not save deal without multiple use" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today, 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.tomorrow
    end_date = start_date + 1.days
    redeemable = true
    multiple_use = nil

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    assert_not deal.save
  end

  test "should not save deal if plan expired" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today.months_ago(12), 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.tomorrow
    end_date = start_date + 1.days
    redeemable = true
    multiple_use = true

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    assert_not deal.save
  end

  test "view deal" do
    # Create deal
    merchant = merchant_one
    merchant.save
    deal = save_waiting_deal(merchant)

    # check deal exists
    deal_query = Deal.find(deal.id)
    assert_not_nil deal_query
  end

  test "edit deal" do
    # Create deal
    merchant = merchant_one
    merchant.save
    deal = save_waiting_deal(merchant)

    title = "new title"
    deal.update(title: title)
    assert_equal "new title", deal.title
  end

  test "delete deal" do
    # Create deal
    merchant = merchant_one
    merchant.save
    deal = save_waiting_deal(merchant)

    # delete deal
    assert_difference('Deal.count', -1) do
      deal.destroy
    end
  end

  test "should not save deal without venue" do
    merchant = merchant_one
    merchant.save

    payment = payment_one(Date.today, 1)
    payment.save

    start_date = Date.tomorrow
    end_date = start_date + 1.days
    redeemable = true
    multiple_use = true

    deal = save_deal_one(merchant.id, nil, start_date, end_date, redeemable, multiple_use)
    assert_not deal.save
  end

  private
  def save_deal_one(merchant, venue, start_date, end_date, redeemable, multiple_use)
    created_at = Date.today
    deal = Deal.new(id: 9999, title: 'Yangpa Bomb Introductory Promo', type_of_deal: 'Discount',
             description: 'Get our new flavor of chicken at 20% off!', t_c: 'While stock last!',
             start_date: start_date, expiry_date: end_date, redeemable: redeemable, multiple_use: multiple_use,
             pushed: false, merchant_id: merchant, active: false, num_of_redeems: 0, created_at: created_at, updated_at: created_at)

    start_time_1 = Time.at(36000).utc.strftime("%H:%M:%S")
    end_time_1 = Time.at(79200).utc.strftime("%H:%M:%S")
    DealTime.create(id: 9999, deal_day_id: 9999, started_at: start_time_1, ended_at: end_time_1)
    DealDay.create(id: 9999, deal_id: 9999, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false)

    DealVenue.create(id: 9999, deal_id: 9999, venue_id: venue)
    deal
  end

  private
  def save_waiting_deal(merchant)
    payment = payment_one(Date.today, 1)
    payment.save

    name = "Chicken Up @ Tampines"
    street = '2 Tampines Central 5'
    zipcode = '529509'
    neighbourhood = 'Tampines'
    phone = '65880308'
    venue = venue_one(name, street, zipcode, neighbourhood, phone)
    venue.save

    start_date = Date.tomorrow
    end_date = start_date + 1.days
    redeemable = true
    multiple_use = true

    deal = save_deal_one(merchant.id, venue.id, start_date, end_date, redeemable, multiple_use)
    deal.save
    deal
  end
end
