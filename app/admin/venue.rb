ActiveAdmin.register Venue do
  menu :parent => "Merchant", :priority => 2

  filter :merchant
  filter :deals
  filter :name
  filter :neighbourhood
  filter :city
  filter :state
  filter :country

  index do
    selectable_column
    column "Deal Id", :id
    column "Merchant", :merchant_id do |venue|
      auto_link venue.merchant
    end
    column "Venue", :name
    column "Information", :bio
    column "Contact Number", :phone
    column "Neighbourhood", :neighbourhood
    column "Country", :country
    actions
  end

  form do |f|
    f.inputs "Venue Info" do
      f.input :merchant, label: "Select merchant"
      f.input :name
      f.input :bio, input_html: { rows: 5 }
      f.input :phone
    end

    f.inputs "Location" do
      f.input :neighbourhood
      f.input :street
      f.input :address_2
      f.input :zipcode
      f.input :city
      f.input :state
      f.input :country, as: :string
    end
    f.actions
  end

  # Allow edit
  permit_params :name, :street, :zipcode, :city, :city, :state, :country, :neighbourhood, :bio, :phone, :address_2, :contact_number
end
