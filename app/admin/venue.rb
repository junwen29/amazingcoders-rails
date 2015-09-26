ActiveAdmin.register Venue do
  menu :parent => "Merchant", :priority => 2

  filter :merchant
  filter :deals
  filter :name
  filter :city
  filter :state
  filter :country

  action_item :only => :show do
    link_to "Back", "/admin/venues"
  end

  index do
    selectable_column
    column "Id", :id
    column "Merchant", :merchant_id do |venue|
      auto_link venue.merchant
    end
    column "Venue", :name
    column "Information", :bio
    column "Street", :street
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
