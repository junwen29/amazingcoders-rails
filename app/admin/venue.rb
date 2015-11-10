ActiveAdmin.register Venue do
  # Remove Create New Deal button
  config.clear_action_items!
  config.sort_order = "created_at_desc"
  
  menu :parent => "Merchant", :priority => 2

  filter :merchant
  filter :deals
  filter :name

  action_item :only => :show do
    link_to "Back", "/admin/venues"
  end

  controller do
    def destroy
      @venue = Venue.find(params[:id])
      if VenueService.allow_delete(@venue.id)
        @venue.destroy
        flash[:success] = "Venue deleted!"
        redirect_to admin_venues_path
      else
        flash[:error] = "Venue cannot be deleted as there is a deal that is only associated with this venue. Please delete associated deal first!"
        redirect_to admin_venues_path
      end
    end
  end

  index do
    selectable_column
    column "Id", :id
    column "Merchant", sortable: 'venue.merchant' do |venue|
      auto_link venue.merchant
    end
    column "Venue", sortable: 'name' do |venue|
      div :class => "venuesCol" do
        venue.name
      end
    end
    column "Information" do |venue|
      div :class => "descriptionCol" do
        venue.bio
      end
    end
    column "Street" do |venue|
      div :class => "venuesCol" do
        venue.street
      end
    end
    actions
  end

  form do |f|
    f.inputs "Venue Info" do
      f.input :merchant, label: "Select merchant"
      f.input :name
      f.input :bio, input_html: { rows: 5 }, label: 'Description'
      f.input :phone
    end

    f.inputs "Location" do
      f.input :neighbourhood
      f.input :street
      f.input :address_2
      f.input :zipcode
    end
    f.actions
  end

  # SHOW
  show do |f|
    panel "Venue Information" do
      attributes_table_for f do
        row :merchant
        row :name
        row "Description" do
          f.bio
        end
        row :phone
        row :neighbourhood
        row :street
        row :address_2
        row :zipcode
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments # Add this line for comment block
  end


  # Allow edit
  permit_params :name, :street, :zipcode, :city, :city, :state, :country, :neighbourhood, :bio, :phone, :address_2, :contact_number
end
