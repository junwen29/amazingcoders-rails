require 'test_helper'

class DealTest < ActiveSupport::TestCase
  test "save waiting deal" do
    start_date = '01-12-2015'.to_date
    end_date = '02-12-2015'.to_date
    created_at = Time.now
    start_time_1 = Time.at(36000).utc.strftime("%H:%M:%S")
    end_time_1 = Time.at(79200).utc.strftime("%H:%M:%S")

    Deal.new(id: '9999', title: 'deal_title', redeemable: true, type_of_deal: 'Discount',
             description: 'deal_description', start_date: start_date, expiry_date: end_date,
             t_c: 'deal_tc', pushed: false, merchant_id: merchants(:tmerchant).id, active: false, num_of_redeems: 0, created_at: created_at).save
    DealDay.new(id: '9999', deal_id: 9999, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save
    DealTime.create(id: '9999', deal_day_id: 9999, started_at: start_time_1, ended_at: end_time_1)
    DealTime.create(id: '9999', deal_day_id: 9999, started_at: start_time_2, ended_at: end_time_2)
    DealVenue.create(id: '9999', deal_id: 9999, venue_id: venues(:tvenue).id)
  end
end
