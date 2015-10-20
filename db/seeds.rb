# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


Plan.create(id: '1', name: 'Premium Deals Services', cost: '30', description: 'Allows unlimited creation of deals. Publishing of up to 5 active deals')

AddOn.create(id: '1', name: 'Push Notification', cost: '5', description: 'Allows 1 Push Notification per deal to Burpple users who have wishlisted your venue!', addon_type: 'notification', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '2', name: 'Deals Statistics', cost: '5', description: 'See demographics of users to target your deals better!', addon_type: 'statistics', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '3', name: 'Aggregate Trends', cost: '5', description: 'See popular keywords and trends across different deals!', addon_type: 'trends', created_at: Time.current, updated_at: Time.current, plan_id: '1')


# For payment analytics
Plan.create(id: '100', name: 'Reservations', cost: '45', description: 'Test payment analytics', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
AddOn.create(id: '100', payment_id: '100', plan_id: '100', name: 'Reservation Notifications', cost: '10', description: 'Test payment analytics', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
Payment.new(id: '100', start_date: '2015-10-01', expiry_date: '2015-12-01', total_cost: '110.00', add_on1: false, add_on2: false, add_on3: false, plan1: false, paid: true, created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00', merchant_id: '2', months: '2').save(validate: false)
PlanPayment.create(id: '100', plan_id: '100', payment_id: '100', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
AddOnPayment.create(id: '100', add_on_id: '100', payment_id: '100', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')

# Seed User Query Table
UserQuery.create(id: '1000', query: 'lunch', num_count: '1921', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1001', query: 'dinner', num_count: '2895', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1002', query: '1 for 1', num_count: '3921', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1003', query: 'delicious', num_count: '1494', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1004', query: 'cheap', num_count: '2516', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1005', query: 'salmon', num_count: '1891', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1006', query: 'local', num_count: '2019', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1007', query: 'amazing deals', num_count: '1721', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1008', query: 'limited time', num_count: '4912', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1009', query: 'savings', num_count: '3612', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)
UserQuery.create(id: '1010', query: 'buffet', num_count: '3812', query_type: 'DealsFeed', created_at: Date.today.beginning_of_day)

# Seed Data for number of wish listers
i = 1000
while i < 1132
  Wish.create(id: i, venue_id: 1, user_id: i)
  i = i + 1
end

while i < 1301
  Wish.create(id: i, venue_id: 2, user_id: i)
  i = i + 1
end

while i < 1451
  Wish.create(id: i, venue_id: 3, user_id: i)
  i = i + 1
end

# Seed Data for Redemptions
i = 1000
start_date = DateTime.parse("2015-09-25 00:00:00")
end_date = DateTime.parse("2015-10-20 00:00:00")
while start_date <= end_date
  limit = i + rand(0..30)
  venue_id = rand(1..3)
  while i < limit
    Redemption.create(id: i, deal_id: 2, user_id: i, venue_id: venue_id, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-10-10 00:00:00")
end_date = DateTime.parse("2015-12-01 00:00:00")
while start_date <= end_date
  limit = i + rand(0..30)
  venue_id = rand(1..3)
  while i < limit
    Redemption.create(id: i, deal_id: 3, user_id: i, venue_id: venue_id, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-10-15 00:00:00")
end_date = DateTime.parse("2015-12-01 00:00:00")
while start_date <= end_date
  limit = i + rand(0..30)
  venue_id = rand(1..3)
  while i < limit
    Redemption.create(id: i, deal_id: 4, user_id: i, venue_id: venue_id, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-10-19 00:00:00")
end_date = DateTime.parse("2015-12-01 00:00:00")
while start_date <= end_date
  limit = i + rand(0..30)
  venue_id = rand(1..3)
  while i < limit
    Redemption.create(id: i, deal_id: 5, user_id: i, venue_id: venue_id, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end




