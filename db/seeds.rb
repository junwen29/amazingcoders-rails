# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# TODO: Change this data to presentation date and data for analytics will be seeding till that date
final_end_date = "2015-11-18 00:00:00"

Plan.create(id: '1', name: 'Premium Deals Services', cost: '30', description: 'Allows unlimited creation of deals. Publishing of up to 5 active deals')

AddOn.create(id: '1', name: 'Push Notification', cost: '5', description: 'Allows 1 Push Notification per deal to Burpple users who have wishlisted your venue!', addon_type: 'Notification', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '2', name: 'Deals Statistics', cost: '5', description: 'See demographics of users to target your deals better!', addon_type: 'Statistics', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '3', name: 'Aggregate Trends', cost: '5', description: 'See popular keywords and trends across different deals!', addon_type: 'Trends', created_at: Time.current, updated_at: Time.current, plan_id: '1')


# For payment analytics
Plan.create(id: '1000', name: 'Reservations', cost: '50', description: 'Test payment analytics', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
AddOn.create(id: '1000', plan_id: '1000', name: 'Reservation Notifications', cost: '10', description: 'Reservation Notification', addon_type: 'Notification', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
AddOn.create(id: '1001', plan_id: '1000', name: 'Reservation Statistics', cost: '10', description: 'Reservation Statistics', addon_type: 'Statistics', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')

# For Gifts
Gift.create(id: '1000', name: '1 free month', points: '600', description: 'Free 1 month subscription to Premium Deals Services with all add-ons. Simply click redeem and select the start date of your plan!', gift_type: 'Merchant', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
Gift.create(id: '1001', name: 'Featured Post', points: '100', description: 'Get 1 month of featured post on Burpple!', gift_type: 'Merchant', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')
Gift.create(id: '1002', name: 'Burpple Mug', points: '100', description: 'Get a Burpple Mug Merchandise!', gift_type: 'Merchant', created_at: '2015-10-01 00:00:00', updated_at: '2015-10-01 00:00:00')

# Seed admin
admin = AdminUser.new(id: '1000')
admin.email = 'admin@burpple.com'
admin.password = 'password'
admin.password_confirmation = 'password'
admin.save

# Seed Merchant
merchant = Merchant.new(id: '1000')
merchant.email = 'amazingcoders8mc@gmail.com'
merchant.password = 'burppleadmin'
merchant.password_confirmation = 'burppleadmin'
merchant.save

merchant = Merchant.new(id: '1001')
merchant.email = 'woonyong92@gmail.com'
merchant.password = '12345678'
merchant.password_confirmation = '12345678'
merchant.save

merchant = Merchant.new(id: '1002')
merchant.email = 'jkcheong92@gmail.com'
merchant.password = '12345678'
merchant.password_confirmation = '12345678'
merchant.save

merchant = Merchant.new(id: '1003')
merchant.email = 'junwen29@gmail.com'
merchant.password = '12345678'
merchant.password_confirmation = '12345678'
merchant.save

merchant_id = 1004
while merchant_id < 1010
  merchant = Merchant.new(id: merchant_id)
  merchant.email = merchant_id.to_s + '@gmail.com'
  merchant.password = '12345678'
  merchant.password_confirmation = '12345678'
  merchant.save
  merchant_id = merchant_id + 1
end
while merchant_id <= 1050
  merchant = Merchant.new(id: merchant_id)
  merchant.email = merchant_id.to_s + '@gmail.com'
  merchant.password = '12345678'
  merchant.password_confirmation = '12345678'
  merchant.save
  merchant_id = merchant_id + 1
end
while merchant_id <= 1100
  merchant = Merchant.new(id: merchant_id)
  merchant.email = merchant_id.to_s + '@gmail.com'
  merchant.password = '12345678'
  merchant.password_confirmation = '12345678'
  merchant.save
  merchant_id = merchant_id + 1
end

# users that have already been seeded
seeded_users = Array.new
# Seed 100 users
user = User.new(id: 999)
user.first_name = 'Ser Ming'
user.last_name = 'Goh'
user.username = 'serming'
user.email = 'gohserming@gmail.com'
user.password ='12345678'
user.password_confirmation = '12345678'
user.save

user_id = 1000
while user_id < 1100
  user = User.new(id: user_id)
  user.first_name = 'user'+user_id.to_s
  user.last_name = 'user'+user_id.to_s
  user.username = 'user'+user_id.to_s
  user.email = 'user'+user_id.to_s+'@gmail.com'
  user.password ='12345678'
  user.password_confirmation = '12345678'
  user.save
  seeded_users << user_id
  user_id = user_id + 1
end

# Seed payments and associated tables
payment_id = 1000
plan_payment_id = 1000
add_on_payment_id = 1000

start_date = '01-05-2015'.to_date
end_date = start_date + 1.years
start_datetime = start_date.to_datetime.in_time_zone('Singapore').beginning_of_day
Payment.new(id: 1000, start_date: start_date, expiry_date: end_date, total_cost: 540, add_on1: true, add_on2: true,
            add_on3: true, plan1: true, paid: true, merchant_id: '1000', months: 12, created_at: start_datetime).save(validate: false)
PlanPayment.create(id: plan_payment_id, plan_id: 1, payment_id: payment_id, created_at: start_datetime)
AddOnPayment.create(id: add_on_payment_id, add_on_id: 1, payment_id: payment_id, created_at: start_datetime)
add_on_payment_id = add_on_payment_id + 1
AddOnPayment.create(id: add_on_payment_id, add_on_id: 2, payment_id: payment_id, created_at: start_datetime)
add_on_payment_id = add_on_payment_id + 1
AddOnPayment.create(id: add_on_payment_id, add_on_id: 3, payment_id: payment_id, created_at: start_datetime)
payment_id = payment_id + 1
plan_payment_id = plan_payment_id + 1
add_on_payment_id = add_on_payment_id + 1

start_date = '01-09-2015'.to_date
end_date = start_date + 3.months
start_datetime = start_date.to_datetime.in_time_zone('Singapore').beginning_of_day
Payment.new(id: 1001, start_date: start_date, expiry_date: end_date, total_cost: 90, add_on1: false, add_on2: false,
            add_on3: false, plan1: true, paid: true, merchant_id: '1001', months: 3, created_at: start_datetime).save(validate: false)
PlanPayment.create(id: plan_payment_id, plan_id: 1, payment_id: payment_id, created_at: start_datetime)
payment_id = payment_id + 1
plan_payment_id = plan_payment_id + 1

start_date = '01-01-2015'.to_date
end_date = start_date + 11.months
start_datetime = start_date.to_datetime.in_time_zone('Singapore').beginning_of_day
Payment.new(id: 1002, start_date: start_date, expiry_date: end_date, total_cost: 385, add_on1: true, add_on2: false,
            add_on3: false, plan1: true, paid: true, merchant_id: '1002', months: 11, created_at: start_datetime).save(validate: false)
PlanPayment.create(id: plan_payment_id, plan_id: 1, payment_id: payment_id, created_at: start_datetime)
AddOnPayment.create(id: add_on_payment_id, add_on_id: 1, payment_id: payment_id, created_at: start_datetime)
payment_id = payment_id + 1
plan_payment_id = plan_payment_id + 1
add_on_payment_id = add_on_payment_id + 1

# merchant_id 1003 has no payment

merchant_id = 1004
start_date = '01-12-2014'.to_date
start_datetime = start_date.to_datetime.in_time_zone('Singapore').beginning_of_day
end_date = start_date + 2.months
while merchant_id < 1010
  Payment.new(id: payment_id, start_date: start_date, expiry_date: end_date, total_cost: '140.00', add_on1: false, add_on2: false,
              add_on3: false, plan1: false, paid: true, created_at: start_datetime, updated_at: start_datetime, merchant_id: merchant_id, months: 2).save(validate: false)
  PlanPayment.create(id: plan_payment_id, plan_id: 1000, payment_id: payment_id, created_at: start_datetime, updated_at: start_datetime)
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 1000, payment_id: payment_id, created_at: start_datetime, updated_at: start_datetime)
  add_on_payment_id = add_on_payment_id + 1
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 1001, payment_id: payment_id, created_at: start_datetime, updated_at: start_datetime)
  start_date = start_date + 1.months
  end_date = start_date + 2.months
  start_datetime = start_date.to_datetime.in_time_zone('Singapore').beginning_of_day
  payment_id = payment_id + 1
  merchant_id = merchant_id + 1
  plan_payment_id = plan_payment_id + 1
  add_on_payment_id = add_on_payment_id + 1
end


start_date = '01-12-2014'.to_date
end_date = start_date + 1.months
while merchant_id < 1050
  Payment.new(id: payment_id, start_date: start_date, expiry_date: end_date, total_cost: '45.00', add_on1: true, add_on2: true, add_on3: true, plan1: true, paid: true, created_at: start_date, updated_at: '2015-10-01 00:00:00', merchant_id: merchant_id, months: 1).save(validate: false)
  PlanPayment.create(id: plan_payment_id, plan_id: 1, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 1, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  add_on_payment_id = add_on_payment_id + 1
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 2, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  add_on_payment_id = add_on_payment_id + 1
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 3, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  if merchant_id%rand(5..10) == 0
    start_date = end_date
    end_date = end_date + 1.months
  end
  payment_id = payment_id + 1
  merchant_id = merchant_id + 1
  plan_payment_id = plan_payment_id + 1
  add_on_payment_id = add_on_payment_id + 1
end

while merchant_id < 1100
  created_at = '01-10-2015'.to_date
  Payment.new(id: payment_id, start_date: start_date, expiry_date: end_date, total_cost: '40.00', add_on1: true, add_on2: true, add_on3: false, plan1: true, paid: true, created_at: created_at, updated_at: '2015-10-01 00:00:00', merchant_id: merchant_id, months: 1).save(validate: false)
  PlanPayment.create(id: plan_payment_id, plan_id: 1, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 1, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  add_on_payment_id = add_on_payment_id + 1
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 2, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  if merchant_id%rand(5..10) == 0
    start_date = end_date
    end_date = end_date + 1.months
  end
  payment_id = payment_id + 1
  merchant_id = merchant_id + 1
  plan_payment_id = plan_payment_id + 1
  add_on_payment_id = add_on_payment_id + 1
end

start_date = '01-11-2015'.to_date
end_date = start_date + 1.months
merchant_id = 1010
id = 1100
while merchant_id < 1050
  Payment.new(id: payment_id, start_date: start_date, expiry_date: end_date, total_cost: '45.00', add_on1: true, add_on2: true, add_on3: true, plan1: true, paid: true, created_at: start_date, updated_at: '2015-10-01 00:00:00', merchant_id: merchant_id, months: 1).save(validate: false)
  PlanPayment.create(id: plan_payment_id, plan_id: 1, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 1, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  add_on_payment_id = add_on_payment_id + 1
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 2, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  add_on_payment_id = add_on_payment_id + 1
  AddOnPayment.create(id: add_on_payment_id, add_on_id: 3, payment_id: payment_id, created_at: start_date, updated_at: '2015-10-01 00:00:00')
  payment_id = payment_id + 1
  id = id + 1
  merchant_id = merchant_id + 1
  plan_payment_id = plan_payment_id + 1
  add_on_payment_id = add_on_payment_id + 1
end

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
Venue.create(id: '1009', name: 'Chicken Up @ Bugis', street: '60 Queen Street Singapore', zipcode: '188540', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Bugis',  bio: 'ChickenUp is well known and best
+loved for serving Authentic Korean Fried Chicken. By adapting the Korean methods of removing the fat from the skin and
+double-frying, Chicken Up Created its own distinct variation of fried chicken, featuring juicy, sumptuous and tender
+chicken meat under its thin and crunchy skin without being too greasy. Best known for its signature SpicyUp and YangNyum
+style fried chicken. ChickenUp also serves several variations of the dish with the accompaniment of different sauces
+such as soya and curry sauces.', phone: '609690', merchant_id: 1000)
# Seeded for admin to delete
Venue.create(id: '1010', name: 'Chicken Down @ Redhill', street: '60 Queen Street Singapore', zipcode: '188540', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Bugis',  bio: 'ChickenUp is well known and best
+loved for serving Authentic Korean Fried Chicken. By adapting the Korean methods of removing the fat from the skin and
+double-frying, Chicken Up Created its own distinct variation of fried chicken, featuring juicy, sumptuous and tender
+chicken meat under its thin and crunchy skin without being too greasy. Best known for its signature SpicyUp and YangNyum
+style fried chicken. ChickenUp also serves several variations of the dish with the accompaniment of different sauces
+such as soya and curry sauces.', phone: '609690', merchant_id: 1001)
# For woonyong92@gmail.com
Venue.create(id: '1003', name: 'Reedz Cafe', street: '15 Kent Ridge Drive', zipcode: '119245', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Kent Ridge',
             bio: 'A chic cafe tucked-away in a quaint corner of the NUS Kent Ridge Campus', phone: '67745898',
             merchant_id: 1001)
# For jkcheong92@gmail.com
Venue.create(id: '1004', name: 'Eighteen Chefs @ Bukit Panjang', street: '1 Jelebu Road', zipcode: '677743', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Bukit Panjang',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '67670557', address_2: '#02-19', merchant_id: 1002)
Venue.create(id: '1005', name: 'Eighteen Chefs @ Ang Mo Kio', street: '53 Ang Mo Kio Avenue 3', zipcode: '677743', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Ang Mo Kio',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '64817625', address_2: '#04-02', merchant_id: 1002)
Venue.create(id: '1006', name: 'Eighteen Chefs @ Bugis', street: '200 Victoria Street', zipcode: '188021', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Bugis',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '67349741', address_2: '#04-06', merchant_id: 1002)
Venue.create(id: '1007', name: 'Eighteen Chefs @ Simei', street: '3 Simei Street 6', zipcode: '528833', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Simei',
             bio: 'Here at Eighteen Chefs, we strive to provide our customers with good quality food at an affordable price',
             phone: '67892852', address_2: '#01-12', merchant_id: 1002)

# For testing merchant
Venue.create(id: '1008', name: 'Food for Life', street: '181 Orchard Rd', zipcode: '238896', city: 'Singapore',
             state: 'Singapore', country: 'Singapore', neighbourhood: 'Orchard',
             bio: 'A savoury twist to Singapore food scene focused on affordable but quality experience',
             phone: '65095895', address_2: '#08-08', merchant_id: 1004)

# Seed Deals and it's related tables
start_time_1 = Time.at(36000).utc.strftime("%H:%M:%S")
end_time_1 = Time.at(79200).utc.strftime("%H:%M:%S")
start_time_2 = Time.at(39600).utc.strftime("%H:%M:%S")
end_time_2 = Time.at(75600).utc.strftime("%H:%M:%S")

# Seed deals for amazingcoders8mc@gmail.com
activate_date = '30-09-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
start_date = '01-10-2015'.to_date
end_date = '20-10-2015'.to_date
created_at = start_date - 10.days
Deal.new(id: '1000', title: 'Yangpa Bomb Introductory Promo', redeemable: false, type_of_deal: 'Discount',
         description: 'Get our new flavor of chicken at 20% off!', start_date: start_date, expiry_date: end_date,
         t_c: 'While stock last!', pushed: true, merchant_id: 1000, active: true, num_of_redeems: 0, created_at: created_at,
         activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1000', deal_id: 1000, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1001', deal_id: 1000, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1000', deal_day_id: 1000, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1001', deal_day_id: 1001, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1000', deal_id: 1000, venue_id: 1000)
DealVenue.create(id: '1001', deal_id: 1000, venue_id: 1001)
DealVenue.create(id: '1002', deal_id: 1000, venue_id: 1002)

start_date = '10-10-2015'.to_date
end_date = '20-10-2015'.to_date
created_at = start_date - 10.days
activate_date = '09-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1001', title: '1 For 1 Chicken Up Wings and Korean Bingsu', redeemable: true, multiple_use: false, type_of_deal: 'Freebies',
         description: 'For every wing or bingsu purchased you get another on the house! Enjoy!!!', start_date: start_date, expiry_date: end_date,
         t_c: 'While stock last!', pushed: true, merchant_id: 1000, active: true, num_of_redeems: 0, created_at: created_at, activate_date: activate_date,
         push_date: activate_date).save(validate: false)
DealDay.new(id: '1002', deal_id: 1001, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1003', deal_id: 1001, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1002', deal_day_id: 1002, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1003', deal_day_id: 1003, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1003', deal_id: 1001, venue_id: 1000)
DealVenue.create(id: '1004', deal_id: 1001, venue_id: 1001)
DealVenue.create(id: '1005', deal_id: 1001, venue_id: 1002)

start_date = '25-10-2015'.to_date
end_date = '01-12-2015'.to_date
created_at = start_date - 10.days
activate_date = '23-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1002', title: '1 Free Soju Cocktails for every Main Meal Purchased', redeemable: true, multiple_use: true, type_of_deal: 'Freebies',
         description: 'Normal Price $25++. Now only $17', start_date: start_date, expiry_date: end_date,
         t_c: 'Deal must be redeemed via Burpple! Only valid for 18 and above', pushed: true, merchant_id: 1000, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1004', deal_id: 1002, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1005', deal_id: 1002, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1004', deal_day_id: 1004, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1005', deal_day_id: 1005, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1006', deal_id: 1002, venue_id: 1000)
DealVenue.create(id: '1007', deal_id: 1002, venue_id: 1001)
DealVenue.create(id: '1008', deal_id: 1002, venue_id: 1002)

start_date = '28-10-2015'.to_date
end_date = '01-12-2015'.to_date
created_at = start_date - 10.days
activate_date = '25-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1003', title: '4pcs Fried Chicken @ $8.00', redeemable: true, multiple_use: false, type_of_deal: 'Discount',
         description: 'Normal Price $12++. Now only $8.00', start_date: start_date, expiry_date: end_date,
         t_c: 'Deal must be redeemed via Burpple!', pushed: true, merchant_id: 1000, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1006', deal_id: 1003, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1007', deal_id: 1003, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1006', deal_day_id: 1006, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1007', deal_day_id: 1007, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1009', deal_id: 1003, venue_id: 1000)
DealVenue.create(id: '1010', deal_id: 1003, venue_id: 1001)
DealVenue.create(id: '1011', deal_id: 1003, venue_id: 1002)

start_date = '24-10-2015'.to_date
end_date = '01-12-2015'.to_date
created_at = start_date - 10.days
activate_date = '20-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1004', title: '50% OFF Ganjang, Yanguyum Wings and Soju Cocktails!', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: '50% OFF!!!', start_date: start_date, expiry_date: end_date,
         t_c: 'Deal must be redeemed via Burpple! Soju Cocktails is valid only or 18 and above', pushed: true,
         merchant_id: 1000, active: true, num_of_redeems: 0, created_at: created_at, activate_date: activate_date,
         push_date: activate_date).save(validate: false)
DealDay.new(id: '1008', deal_id: 1004, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1009', deal_id: 1004, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1008', deal_day_id: 1008, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1009', deal_day_id: 1009, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1012', deal_id: 1004, venue_id: 1000)
DealVenue.create(id: '1013', deal_id: 1004, venue_id: 1001)
DealVenue.create(id: '1014', deal_id: 1004, venue_id: 1002)

start_date = '05-10-2015'.to_date
end_date = '11-10-2015'.to_date
created_at = start_date - 10.days
Deal.new(id: '1005', title: 'Citibank Card Holders enjoy 10% Off', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: '10% Off when you use CitiBank card to pay', start_date: start_date, expiry_date: end_date,
         t_c: 'Citibank Card holders. Deal must be redeemed through burpple. Deal is valid for dine-in only', pushed: false,
         merchant_id: 1000, active: false, num_of_redeems: 0, created_at: created_at).save(validate: false)
DealDay.new(id: '1010', deal_id: 1005, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1011', deal_id: 1005, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1010', deal_day_id: 1010, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1011', deal_day_id: 1011, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1015', deal_id: 1005, venue_id: 1000)
DealVenue.create(id: '1016', deal_id: 1005, venue_id: 1001)
DealVenue.create(id: '1017', deal_id: 1005, venue_id: 1002)

start_date = '01-12-2015'.to_date
end_date = '10-12-2015'.to_date
created_at = start_date - 20.days
Deal.new(id: '1006', title: 'ONLY $9.90 Off Korean Chicken',
         redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: '59% off Korean Half Chicken. Serves 2 pax. Choose from 4 flavours: Spicy Up, Mild Up, Curry Up, Yanghyum',
         start_date: start_date, expiry_date: end_date, t_c: 'Valid for dine-in only', pushed: false, merchant_id: 1000,
         active: false, num_of_redeems: 0, created_at: created_at).save(validate: false)
DealDay.new(id: '1012', deal_id: 1006, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealDay.new(id: '1013', deal_id: 1006, mon: false, tue: false, wed: false, thur: false, fri: false, sat: true, sun: true).save(validate: false)
DealTime.create(id: '1012', deal_day_id: 1012, started_at: start_time_1, ended_at: end_time_1)
DealTime.create(id: '1013', deal_day_id: 1013, started_at: start_time_2, ended_at: end_time_2)
DealVenue.create(id: '1018', deal_id: 1006, venue_id: 1000)
DealVenue.create(id: '1019', deal_id: 1006, venue_id: 1001)
DealVenue.create(id: '1020', deal_id: 1006, venue_id: 1002)

# Seed Deal Data for woonyong92@gmail.com
start_date = '01-09-2015'.to_date
end_date = '24-11-2015'.to_date
created_at = start_date - 10.days
Deal.new(id: '1007', title: '10% Off Total Bill', redeemable: false, multiple_use: false, type_of_deal: 'Discount',
         description: '10% Off Total Bill for NUS Staff and Students', start_date: start_date, expiry_date: end_date,
         t_c: 'Only for Dine in. Only valid for NUS Student or Staff', pushed: true, merchant_id: 1001, active: true,
         num_of_redeems: 0, created_at: created_at).save(validate: false)
DealDay.new(id: '1014', deal_id: 1007, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1014', deal_day_id: 1014, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1021', deal_id: 1007, venue_id: 1003)

start_date = '01-10-2015'.to_date
end_date = '24-11-2015'.to_date
created_at = start_date - 10.days
Deal.new(id: '1008', title: 'Citibank Card Holders enjoy 10% Off', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: '10% Off when you use CitiBank card to pay', start_date: start_date, expiry_date: end_date,
         t_c: 'Only for Dine in. Only valid for NUS Student or Staff', pushed: true, merchant_id: 1001, active: true,
         num_of_redeems: 0, created_at: created_at).save(validate: false)
DealDay.new(id: '1015', deal_id: 1008, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1015', deal_day_id: 1015, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1022', deal_id: 1008, venue_id: 1003)

# Seed Deal Data for jkcheong92@gmail.com
start_date = '01-01-2015'.to_date
end_date = '24-04-2015'.to_date
created_at = start_date - 10.days
activate_date = '30-12-2014'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1009', title: '18 Chefs SG50 Set Meal 1 For 1', redeemable: true, multiple_use: true, type_of_deal: 'Freebies',
         description: 'Open Heart Surgery Fried Rice (for 4), Black Beauty, Peach in a Jar, Homemade Ice Lemon Tea x4 buy 1 get 1 free!',
         start_date: start_date, expiry_date: end_date, t_c: 'Not valid for Eighteen Chefs employees & their families. Dine in only',
         pushed: true, merchant_id: 1002, active: true, num_of_redeems: 0, created_at: created_at, activate_date: activate_date,
         push_date: activate_date).save(validate: false)
DealDay.new(id: '1016', deal_id: 1009, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1016', deal_day_id: 1016, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1023', deal_id: 1009, venue_id: 1004)
DealVenue.create(id: '1024', deal_id: 1009, venue_id: 1005)
DealVenue.create(id: '1025', deal_id: 1009, venue_id: 1006)
DealVenue.create(id: '1026', deal_id: 1009, venue_id: 1007)

start_date = '01-03-2015'.to_date
end_date = '24-08-2015'.to_date
created_at = start_date - 10.days
activate_date = '28-02-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1010', title: 'Student/NSmen Meal Avaliable Any Time And Day', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: 'Pasta/Cheese Baked Rice. Choose from Step 3A, B, C or D. Ice Lemon Tea. Ice Cream. Student from $6.40! NSmen From $7.40',
         start_date: start_date, expiry_date: end_date, t_c: 'Valid only when in uniform or 11B/Student ID presented',
         pushed: true, merchant_id: 1002, active: true, num_of_redeems: 0, created_at: created_at, activate_date: activate_date,
         push_date: activate_date).save(validate: false)
DealDay.new(id: '1017', deal_id: 1010, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1017', deal_day_id: 1017, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1027', deal_id: 1010, venue_id: 1004)
DealVenue.create(id: '1028', deal_id: 1010, venue_id: 1005)
DealVenue.create(id: '1029', deal_id: 1010, venue_id: 1006)
DealVenue.create(id: '1030', deal_id: 1010, venue_id: 1007)

start_date = '01-03-2015'.to_date
end_date = '01-12-2015'.to_date
created_at = start_date - 10.days
activate_date = '25-02-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
Deal.new(id: '1011', title: 'We Love Students, NSmen & Senior Citizens', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: '$2 Discount for Students, NSmen and Seniors (Aged 55 and above) for our All Time Favourites!',
         start_date: start_date, expiry_date: end_date,
         t_c: 'Valid Verification must be presented upon request. Not applicable to student/NSmen meals and other promotional items',
         pushed: true, merchant_id: 1002, active: true, num_of_redeems: 0, created_at: created_at, activate_date: activate_date,
         push_date: activate_date).save(validate: false)
DealDay.new(id: '1018', deal_id: 1011, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1018', deal_day_id: 1018, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1031', deal_id: 1011, venue_id: 1004)
DealVenue.create(id: '1032', deal_id: 1011, venue_id: 1005)
DealVenue.create(id: '1033', deal_id: 1011, venue_id: 1006)
DealVenue.create(id: '1034', deal_id: 1011, venue_id: 1007)

Deal.new(id: '1012', title: 'Free pizza with every set meal purchased', redeemable: true, multiple_use: true, type_of_deal: 'Freebies',
         description: 'Get a Free  Gourment Pizza for every set meal purchased', start_date: start_date, expiry_date: end_date,
         t_c: 'Valid through Burpple only. One redeem per table', pushed: true, merchant_id: 1004, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1020', deal_id: 1012, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1020', deal_day_id: 1020, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1036', deal_id: 1012, venue_id: 1008)

Deal.new(id: '1013', title: 'Enjoy a Matsuri Treat Every WeekDay', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: 'Get Up to 50% off all Items', start_date: start_date, expiry_date: end_date,
         t_c: 'Valid through Burpple only.', pushed: true, merchant_id: 1004, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1021', deal_id: 1013, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1021', deal_day_id: 1021, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1037', deal_id: 1013, venue_id: 1008)

Deal.new(id: '1014', title: 'All you can eat high tea', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: 'Get Up to 50% off all Items', start_date: start_date, expiry_date: end_date,
         t_c: 'Valid through Burpple only.', pushed: true, merchant_id: 1004, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1022', deal_id: 1014, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1022', deal_day_id: 1022, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1038', deal_id: 1014, venue_id: 1008)

Deal.new(id: '1015', title: 'Buy one set meal get another set meal for Free', redeemable: true, multiple_use: true, type_of_deal: 'Freebies',
         description: 'Get a set meal free with every other set meal purchased', start_date: start_date, expiry_date: end_date,
         t_c: 'Valid through Burpple only.', pushed: true, merchant_id: 1004, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1023', deal_id: 1015, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1023', deal_day_id: 1023, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1039', deal_id: 1015, venue_id: 1008)

Deal.new(id: '1016', title: '$2.70 For choice of Frosty Mint or Crunch Toffee Nut Frappe', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: 'Limited time only', start_date: start_date, expiry_date: end_date,
         t_c: 'Valid through Burpple only.', pushed: true, merchant_id: 1004, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1024', deal_id: 1016, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1024', deal_day_id: 1024, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1040', deal_id: 1016, venue_id: 1008)

Deal.new(id: '1017', title: '$14 for FishHead Curry wotth $26', redeemable: true, multiple_use: true, type_of_deal: 'Discount',
         description: 'Limited time only', start_date: start_date, expiry_date: end_date,
         t_c: 'Valid through Burpple only.', pushed: true, merchant_id: 1004, active: true, num_of_redeems: 0,
         created_at: created_at, activate_date: activate_date, push_date: activate_date).save(validate: false)
DealDay.new(id: '1025', deal_id: 1017, mon: true, tue: true, wed: true, thur: true, fri: true, sat: false, sun: false).save(validate: false)
DealTime.create(id: '1025', deal_day_id: 1025, started_at: start_time_1, ended_at: end_time_1)
DealVenue.create(id: '1041', deal_id: 1017, venue_id: 1008)


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
created_at = '20-04-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
while i < 1030
  Wish.create(id: i, venue_id: 1000, user_id: i, created_at: created_at)
  i = i + 1
end

while i < 1070
  Wish.create(id: i, venue_id: 1001, user_id: i, created_at: created_at)
  i = i + 1
end

while i < 1100
  Wish.create(id: i, venue_id: 1002, user_id: i, created_at: created_at)
  i = i + 1
end

# Seed DealAnalytics for View count for deal 1000
view_count = 1000
start_date = DateTime.parse("2015-10-01 00:00:00")
end_date = DateTime.parse("2015-10-20 00:00:00")
created_at = '01-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
user_id = 1000
while user_id < 1078
  limit = user_id + rand(4..12)
  while user_id < limit
    Viewcount.create(id: view_count, deal_id: 1000, user_id: user_id, created_at: created_at, entry: 'merchant_push_notification')
    view_count = view_count + 1
    user_id = user_id + 1
    created_at = created_at + rand(1..3).hours
  end
end
user_id = 1000
while start_date <= end_date
  limit = view_count + rand(20..40)
  while view_count < limit
    if user_id == 1078
      user_id = 1000
    end
    Viewcount.create(id: view_count, deal_id: 1000, user_id: user_id, created_at: start_date)
    view_count = view_count + 1
    user_id = user_id + 1
  end
  start_date = start_date + 1.days
end
num_view_count = view_count - 1000
unique_view_count = num_view_count - 22
DealAnalytic.create(id: 1000, deal_id: 1000, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: 0)

# Users to be seeded
seed_users = Array.new

# Seed DealAnalytics for View count for deal 1001
redemption = 1000
user_id = 1000
start_date = DateTime.parse("2015-10-10 00:00:00")
end_date = DateTime.parse("2015-10-20 00:00:00")
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1040
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1001, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    user_id = user_id + rand(0..1)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-10 00:00:00")
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1020
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1001, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    user_id = user_id + rand(1..3)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-10 00:00:00")
user_id = 1100
while start_date <= end_date
  limit = redemption + rand(rand(10..20)..rand(20..30))
  venue_id = rand(1000..1002)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1001, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - 1000

starting_view_count = view_count
start_date = DateTime.parse("2015-10-09 00:00:00")
end_date = DateTime.parse("2015-10-20 00:00:00")
created_at = '09-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
user_id = 1000
while user_id < 1072
  limit = user_id + rand(4..12)
  while user_id < limit
    Viewcount.create(id: view_count, deal_id: 1001, user_id: user_id, created_at: created_at, entry: 'merchant_push_notification')
    view_count = view_count + 1
    user_id = user_id + 1
    created_at = created_at + rand(1..3).hours
  end
end
user_id = 1000
while start_date <= end_date
  limit = view_count + rand(30..40)
  while view_count < limit
    if user_id == 1078
      user_id = 1000
    end
    Viewcount.create(id: view_count, deal_id: 1001, user_id: user_id, created_at: start_date)
    view_count = view_count + 1
    user_id = user_id + 1
  end
  start_date = start_date + 1.days
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count - rand(50..90)
DealAnalytic.create(id: 1001, deal_id: 1001, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1002
starting_redemption = redemption
user_id = 1000
start_date = DateTime.parse("2015-10-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1070
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1002, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + rand(0..1)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-25 00:00:00")
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1050
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1002, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    user_id = user_id + rand(1..3)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-25 00:00:00")
user_id = 1100
while start_date <= end_date
  limit = redemption + rand(0..rand(5..50))
  venue_id = rand(1000..1002)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1002, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-10-23 00:00:00")
end_date = DateTime.parse(final_end_date)
created_at = '23-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
user_id = 1000
while user_id < 1089
  limit = user_id + rand(4..8)
  while user_id < limit
    Viewcount.create(id: view_count, deal_id: 1002, user_id: user_id, created_at: created_at, entry: 'merchant_push_notification')
    view_count = view_count + 1
    user_id = user_id + 1
    created_at = created_at + rand(1..3).hours
  end
end
user_id = 1000
while start_date <= end_date
  limit = view_count + rand(rand(50..55)..rand(60..120))
  while view_count < limit
    if user_id == 1078
      user_id = 1000
    end
    Viewcount.create(id: view_count, deal_id: 1002, user_id: user_id, created_at: start_date)
    view_count = view_count + 1
    user_id = user_id + 1
  end
  start_date = start_date + 1.days
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1002, deal_id: 1002, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1003
starting_redemption = redemption
user_id = 1000
start_date = DateTime.parse("2015-10-28 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1080
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1003, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    user_id = user_id + rand(0..1)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-28 00:00:00")
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1070
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1003, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + rand(1..3)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-28 00:00:00")
user_id = 1000
while start_date <= end_date
  limit = redemption + rand(0..rand(10..50))
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1070
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1003, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-10-25 00:00:00")
end_date = DateTime.parse(final_end_date)
created_at = '25-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
user_id = 1000
while user_id < 1100
  limit = user_id + rand(4..8)
  while user_id < limit
    Viewcount.create(id: view_count, deal_id: 1003, user_id: user_id, created_at: created_at, entry: 'merchant_push_notification')
    view_count = view_count + 1
    user_id = user_id + 1
    created_at = created_at + rand(1..3).hours
  end
end
user_id = 1000
while start_date <= end_date
  limit = view_count + rand(rand(20..30)..rand(60..100))
  while view_count < limit
    if user_id == 1078
      user_id = 1000
    end
    Viewcount.create(id: view_count, deal_id: 1003, user_id: user_id, created_at: start_date)
    view_count = view_count + 1
    user_id = user_id + 1
  end
  start_date = start_date + 1.days
end

num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1003, deal_id: 1003, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1004
starting_redemption = redemption
user_id = 1000
start_date = DateTime.parse("2015-10-24 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1099
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1004, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    user_id = user_id + rand(0..1)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-24 00:00:00")
while start_date <= end_date
  limit = redemption + rand(0..6)
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1070
      user_id = 1000
    end
    Redemption.create(id: redemption, deal_id: 1004, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + rand(1..3)
  end
  start_date = start_date + rand(1..2).days
end
start_date = DateTime.parse("2015-10-24 00:00:00")
user_id = 1000
while start_date <= end_date
  limit = redemption + rand(0..rand(10..50))
  venue_id = rand(1000..1002)
  while redemption < limit
    if user_id == 1070
      user_id = 1100
    end
    Redemption.create(id: redemption, deal_id: 1004, user_id: user_id, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << user_id
      end
    end
    user_id = user_id + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

while start_date <= end_date
  limit = redemption + rand(0..rand(0..30))
  venue_id = rand(1000..1002)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1004, user_id: redemption, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-10-20 00:00:00")
end_date = DateTime.parse(final_end_date)
created_at = '20-10-2015'.to_datetime.in_time_zone("Singapore") - 8.hours
user_id = 1000
while user_id < 1100
  limit = user_id + rand(4..8)
  while user_id < limit
    Viewcount.create(id: view_count, deal_id: 1004, user_id: user_id, created_at: created_at, entry: 'merchant_push_notification')
    view_count = view_count + 1
    user_id = user_id + 1
    created_at = created_at + rand(1..3).hours
  end
end
user_id = 1000
while start_date <= end_date
  limit = view_count + rand(rand(10..30)..rand(40..50))
  while view_count < limit
    if user_id == 1078
      user_id = 1000
    end
    Viewcount.create(id: view_count, deal_id: 1004, user_id: user_id, created_at: start_date)
    view_count = view_count + 1
    user_id = user_id + 1
  end
  start_date = start_date + 1.days
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1004, deal_id: 1004, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1011
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..30)
  venue_id = rand(1000..1002)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1011, user_id: redemption, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = view_count + rand(20..40)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1011, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1005, deal_id: 1011, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)


venue_id = 1008
# Seed DealAnalytics for View count for deal 1012
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..30)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1012, user_id: redemption, venue_id: venue_id, created_at: start_date)
    redemption = redemption + 1
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = view_count + rand(20..40)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1012, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1006, deal_id: 1012, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1013
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..30)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1013, user_id: redemption, venue_id: venue_id, created_at: start_date)
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
    redemption = redemption + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = view_count + rand(20..40)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1013, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1007, deal_id: 1013, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1014
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..3)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1014, user_id: redemption, venue_id: venue_id, created_at: start_date)
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
    redemption = redemption + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = view_count + rand(0..5)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1014, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1008, deal_id: 1014, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1015
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..7)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1015, user_id: redemption, venue_id: venue_id, created_at: start_date)
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
    redemption = redemption + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = view_count + rand(20..40)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1015, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1009, deal_id: 1015, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1016
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = redemption + rand(0..20)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1016, user_id: redemption, venue_id: venue_id, created_at: start_date)
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
    redemption = redemption + 1
  end
  start_date = start_date + 1
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 00:00:00")
end_date = DateTime.parse(final_end_date)
while start_date <= end_date
  limit = view_count + rand(0..30)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1016, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1010, deal_id: 1016, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed DealAnalytics for View count for deal 1017
starting_redemption = redemption
start_date = DateTime.parse("2015-03-01 01:00:00")
end_date = DateTime.parse(final_end_date) + 1.hours
while start_date <= end_date
  limit = redemption + rand(10..20)
  while redemption < limit
    Redemption.create(id: redemption, deal_id: 1017, user_id: redemption, venue_id: venue_id, created_at: start_date)
    if (start_date == end_date) || (start_date + 1.days == end_date)
      if !seed_users.include? user_id
        seed_users << redemption
      end
    end
    redemption = redemption + 1
  end
  start_date = start_date + 1.day
end
num_redemption = redemption - starting_redemption

starting_view_count = view_count
start_date = DateTime.parse("2015-02-25 01:00:00")
end_date = DateTime.parse(final_end_date) + 1.hours
while start_date <= end_date
  limit = view_count + rand(15..25)
  while view_count < limit
    Viewcount.create(id: view_count, deal_id: 1017, user_id: view_count, created_at: start_date)
    view_count = view_count + 1
  end
  start_date = start_date + 1.day
end
num_view_count = view_count - starting_view_count
unique_view_count = num_view_count- rand(50..90)
DealAnalytic.create(id: 1011, deal_id: 1017, view_count: num_view_count, unique_view_count: unique_view_count, redemption_count: num_redemption)

# Seed users for redemption table
seed_users = seed_users - seeded_users
seed_users.each do |sd|
  user = User.new(id: sd)
  user.first_name = 'user'+sd.to_s
  user.last_name = 'user'+sd.to_s
  user.username = 'user'+sd.to_s
  user.email = 'user'+sd.to_s+'@gmail.com'
  user.password ='12345678'
  user.password_confirmation = '12345678'
  user.save
end

# Merchant Points
MerchantPoint.create(id: 1000, reason: 'Paid for a plan upgrade', points: 1040, operation: 'Credit', merchant_id: 1000)

# User Points
UserPoint.create(id: 1000, reason: 'Redeem Deal', points: 1000, operation: 'Credit', user_id: 1000)