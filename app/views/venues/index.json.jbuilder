json.array!(@venues) do |venue|
  json.extract! venue, :id
  json.url venue_url(venue, format: :json)
end
