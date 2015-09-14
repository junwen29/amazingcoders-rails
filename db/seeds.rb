# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Plan.create(name: 'Premium Deals Services', cost: '$30', description: 'Allows unlimited creation of deals. Publishing
of up to 5 active deals')

Addon.create(name: 'Push Notification', cost: '$5', description: 'Allows 1 Push Notification per Deal')


# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
