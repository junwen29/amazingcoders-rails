# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


Plan.create(id: '1', name: 'Premium Deals Services', cost: '30', description: 'Allows unlimited creation of deals. Publishing of up to 5 active deals')

AddOn.create(id: '1', name: 'Push Notification', cost: '5', description: 'Allows 1 Push Notification per deal to Burpple users who have wishlisted your venue!', addon_type: 'notification', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '2', name: 'Deals Statistics', cost: '5', description: 'See demographics of users to target your deals better!', addon_type: 'statistics', created_at: Time.current, updated_at: Time.current, plan_id: '1')
AddOn.create(id: '3', name: 'Aggregate Trends', cost: '5', description: 'See popular keywords and trends across different deals!', addon_type: 'trends', created_at: Time.current, updated_at: Time.current, plan_id: '1')

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

