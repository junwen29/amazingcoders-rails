# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


Plan.create(id: '1', name: 'Premium Deals Services', cost: '30', description: 'Allows unlimited creation of deals. Publishing of up to 5 active deals')

AddOn.create(id: '1', name: 'Push Notification', cost: '5', description: 'Allows 1 Push Notification per deal to Burpple users who have wishlisted your venue!', addon_type: 'notification', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '2', name: 'Deals Statistics', cost: '5', description: 'See demographics of users to target your deals better!', addon_type: 'statistics', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '3', name: 'Aggregate Trends', cost: '5', description: 'See popular keywords and trends across different deals!', addon_type: 'trends', created_at: Time.current, updated_at: Time.current, plan_id: '1')

