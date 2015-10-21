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

# Seed Merchant
merchant = Merchant.new(id: '1000')
merchant.email = 'amazingcoders8mc@gmail.com'
merchant.password = 'burppleadmin'
merchant.password_confirmation = 'burppleadmin'
merchant.total_points = 0
merchant.save

merchant = Merchant.new(id: '1001')
merchant.email = 'woonyong92@gmail.com'
merchant.password = '12345678'
merchant.password_confirmation = '12345678'
merchant.total_points = 0
merchant.save

merchant = Merchant.new(id: '1002')
merchant.email = 'jkcheong92@gmail.com'
merchant.password = '12345678'
merchant.password_confirmation = '12345678'
merchant.total_points = 0
merchant.save

merchant = Merchant.new(id: '1003')
merchant.email = 'junwen29@gmail.com'
merchant.password = '12345678'
merchant.password_confirmation = '12345678'
merchant.total_points = 0
merchant.save

# Seed payments and associated tables
start_date = '01-05-2015'.to_date
end_date = '01-05-2016'.to_date
Payment.create(id: '1000', start_date: start_date, expiry_date: end_date, total_cost: 540, add_on1: true, add_on2: true,
               add_on3: true, plan1: true, paid: true, merchant_id: '1000', months: 12)
PlanPayment.create(id: '1000', plan_id: 1, payment_id: 1000)
AddOnPayment.create(id: '1000', add_on_id: 1, payment_id: 1000)
AddOnPayment.create(id: '1001', add_on_id: 2, payment_id: 1000)
AddOnPayment.create(id: '1002', add_on_id: 3, payment_id: 1000)

start_date = '01-09-2015'.to_date
end_date = '01-12-2015'.to_date
Payment.create(id: '1001', start_date: start_date, expiry_date: end_date, total_cost: 90, add_on1: false, add_on2: false,
               add_on3: false, plan1: true, paid: true, merchant_id: '1001', months: 3)
PlanPayment.create(id: '1001', plan_id: 1, payment_id: 1001)

start_date = '01-08-2015'.to_date
end_date = '01-12-2015'.to_date
Payment.create(id: '1002', start_date: start_date, expiry_date: end_date, total_cost: 140, add_on1: true, add_on2: false,
               add_on3: false, plan1: true, paid: true, merchant_id: '1002', months: 4)
PlanPayment.create(id: '1002', plan_id: 1, payment_id: 1002)
AddOnPayment.create(id: '1003', add_on_id: 1, payment_id: 1002)

# Seed venues
# For amazingcoders8mc@gmail.com
Venue.create(id: '1000', name: 'Chicken Up @ Tampines', street: '2 Tampines Central 5', zipcode: '529509', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Tampines',
             bio: 'ChickenUp is well known and best loved for serving Authentic Korean Fried Chicken.
By adapting the Korean methods of removing the fat from the skin and double-frying, Chicken Up Created its own distinct
variation of fried chicken, featuring juicy, sumptuous and tender chicken meat under its thin and crunchy skin without
being too greasy. Best known for its signature SpicyUp and YangNyum style fried chicken. ChickenUp also serves several
variations of the dish with the accompaniment of different sauces such as soya and curry sauces.', phone: '65880308',
             address_2: '#01-44 to 47', merchant_id: 1000)
Venue.create(id: '1001', name: 'Chicken Up @ Tanjong Pagar', street: '48 Tanjong Pagar Road', zipcode: '688469', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Tanjong Pagar',
             bio: 'ChickenUp is well known and best loved for serving Authentic Korean Fried Chicken.
By adapting the Korean methods of removing the fat from the skin and double-frying, Chicken Up Created its own distinct
variation of fried chicken, featuring juicy, sumptuous and tender chicken meat under its thin and crunchy skin without
being too greasy. Best known for its signature SpicyUp and YangNyum style fried chicken. ChickenUp also serves several
variations of the dish with the accompaniment of different sauces such as soya and curry sauces.', phone: '63271203',
             address_2: '#01-01', merchant_id: 1000)
Venue.create(id: '1002', name: 'Chicken Up @ Jurong East', street: 'Jurong East MRT, 10 Jurong East St12', zipcode: '609690', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Jurong East',
             bio: 'ChickenUp is well known and best loved for serving Authentic Korean Fried Chicken.
By adapting the Korean methods of removing the fat from the skin and double-frying, Chicken Up Created its own distinct
variation of fried chicken, featuring juicy, sumptuous and tender chicken meat under its thin and crunchy skin without
being too greasy. Best known for its signature SpicyUp and YangNyum style fried chicken. ChickenUp also serves several
variations of the dish with the accompaniment of different sauces such as soya and curry sauces.', phone: '65630337',
             address_2: '#01-01', merchant_id: 1000)
# For woonyong92@gmail.com
Venue.create(id: '1003', name: 'Reedz Cafe', street: '15 Kent Ridge Drive', zipcode: '119245', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Kent Ridge',
             bio: 'A chic cafe tucked-away in a quaint corner of the NUS Kent Ridge Campus', phone: '67745898',
             merchant_id: 1001)
# For jkcheong92@gmail.com
Venue.create(id: '1004', name: 'Eighteen Chefs @ Bukit Panjang', street: '1 Jelebu Road', zipcode: '677743', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Bukit Panjang',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '67670557',  address_2: '#02-19', merchant_id: 1002)
Venue.create(id: '1005', name: 'Eighteen Chefs @ Ang Mo Kio', street: '53 Ang Mo Kio Avenue 3', zipcode: '677743', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Ang Mo Kio',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '64817625',  address_2: '#04-02', merchant_id: 1002)
Venue.create(id: '1006', name: 'Eighteen Chefs @ Bugis', street: '200 Victoria Street', zipcode: '188021', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Bugis',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '67349741',  address_2: '#04-06', merchant_id: 1002)
Venue.create(id: '1007', name: 'Eighteen Chefs @ Simei', street: '3 Simei Street 6', zipcode: '528833', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Simei',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '67892852',  address_2: '#01-12', merchant_id: 1002)

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

# Seed Data for ViewCounts
i = 300000
start_date = DateTime.parse("2015-09-20 00:00:00")
end_date = DateTime.parse("2015-10-20 00:00:00")
while start_date <= end_date
  limit = i + rand(20..40)
  while i < limit
    Viewcount.create(id: i, deal_id: 1, user_id: i, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-09-25 00:00:00")
end_date = DateTime.parse("2015-10-20 00:00:00")
while start_date <= end_date
  limit = i + rand(20..40)
  while i < limit
    Viewcount.create(id: i, deal_id: 2, user_id: i, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-10-01 00:00:00")
end_date = DateTime.parse("2015-12-01 00:00:00")
while start_date <= end_date
  limit = i + rand(20..40)
  while i < limit
    Viewcount.create(id: i, deal_id: 3, user_id: i, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-10-05 00:00:00")
end_date = DateTime.parse("2015-12-01 00:00:00")
while start_date <= end_date
  limit = i + rand(20..40)
  while i < limit
    Viewcount.create(id: i, deal_id: 4, user_id: i, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end

start_date = DateTime.parse("2015-10-10 00:00:00")
end_date = DateTime.parse("2015-12-01 00:00:00")
while start_date <= end_date
  limit = i + rand(20..40)
  while i < limit
    Viewcount.create(id: i, deal_id: 5, user_id: i, created_at: start_date)
    i = i + 1
  end
  start_date = start_date + 1
end
