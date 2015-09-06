# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
location_list = [
    "Alexandra", "Ang Mo Kio", "Ann Siang Hill", "Arab Street",
    "Bayfront", "Bedok", "Bedok Reservoir", "Bencoolen", "Bishan", "Boat Quay", "Boon Keng", "Boon Lay", "Bras Brasah", "Buangkok", "Bugis", "Bukit Batok", "Bukit Merah", "Bukit Panjang", "Bukit Timah", "Buona Vista",
    "Changi", "Chinatown", "Choa Chu Kang", "City Hall", "Clarke Quay", "Clementi",
    "Dempsey", "Dhoby Ghaut", "Dover", "Duxton",
    "Eunos",
    "Farrer Park",
    "Geylang", "Ghim Moh",
    "Harbourfront", "Holland Village", "Hougang",
    "Joo Chiat", "Jurong East",
    "Kallang", "Katong", "Kembangan", "Kent Ridge", "Keppel",
    "Labrador Park", "Lavender", "Lim Chu Kang", "Little India",
    "Macpherson", "Mandai", "Marina Bay", "Marine Parade", "Mountbatten",
    "Newton", "Novena",
    "One North", "Orchard", "Outram",
    "Pasir Panjang", "Pasir Ris", "Paya Lebar", "Potong Pasir", "Pulau Ubin", "Punggol",
    "Queenstown",
    "Raffles Place", "Redhill", "River Valley", "Robertson Quay",
    "Sembawang", "Sengkang", "Sentosa", "Serangoon", "Serangoon Gardens", "Siglap", "Simei", "Simpang", "Sixth Avenue", "Somerset",
    "Tampines", "Tanglin", "Tanjong Pagar", "Telok Blangah", "Thomson", "Tiong Bahru", "Toa Payoh", "Tuas",
    "Upper Bukit Timah",
    "West Coast", "Woodlands",
    "Yio Chu Kang", "Yishun",
]

location_list.each do |location|
  Venue.create( location: location)
end