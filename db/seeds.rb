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

