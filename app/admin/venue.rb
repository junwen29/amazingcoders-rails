ActiveAdmin.register Venue do
  menu :parent => "Merchant", :priority => 2

  index do
    selectable_column
    column :id
    column "Merchant id", :merchant_id
    column "Venue", :name
    column "Information", :bio
    column "Neighbourhood", :neighbourhood
    column "Street", :street
    column "Unit No", :address_2
    column "Zipcode", :zipcode
    column "Country", :country
    column "Contact Number", :phone
    column "Created At", :created_at
    column "Updated At", :updated_at
    actions
  end
end
