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

  form do |f|
    f.inputs "Venue Info" do
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
