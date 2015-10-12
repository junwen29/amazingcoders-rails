ActiveAdmin.register Deal do
  # Remove Create New Deal button
  config.clear_action_items!

  controller do
    def update
      @deal = Deal.find(params[:id])
      if @deal.update_columns(deal_params)
        flash[:success] = "Deal successfully updated!"
        # TODO - DEMO: Uncomment on demonstration
        # merchant_id = @deal.merchant_id
        # DealMailer.update_deal_email_admin("valued merchant", @deal, MerchantService.get_email(merchant_id)).deliver
        redirect_to admin_deal_path
      else
        flash[:error] = "Failed to update deal!"
      end
    end

    private
    def deal_params
      params.require(:deal).permit(:start_date, :title, :redeemable, :multiple_use, :image, :type_of_deal, :description, :location, :t_c, :pushed, :active,
                                   deal_days_attributes: [:id, :mon, :tue, :wed, :thur, :fri, :sat, :sun, :_destroy,
                                                          deal_times_attributes: [:id, :started_at, :ended_at, :_destroy]],
                                   deal_venues_attributes: [:id, :qrCodeLink], venues_attributes: [:id, :location])
    end
  end

  scope :active
  scope :waiting
  scope :expired

  filter :merchant, :collection => proc {(Merchant.all).map{|m| [m.email, m.id]}}
  filter :venues, label: 'Venues',:collection => proc {(Venue.all).map{|v| [v.name, v.id]}}
  filter :type_of_deal
  filter :description
  filter :start_date, label: 'Start Date'
  filter :expiry_date, label: 'Expiry Date'
  filter :multiple_use, label: 'Multiple Use'
  filter :redeemable, label: 'QR Code Redeemable'
  filter :pushed, label: 'Notification Pushed'

  action_item :only => :show do
    link_to "Back", "/admin/deals"
  end

  # INDEX
  index do
    selectable_column
    column "Title", :title
    column "Type", :type_of_deal
    column "Description" do |deal|
      div :class => "descriptionCol" do
        deal.description
      end
    end
    column "Merchant", :merchant_id do |deal|
      auto_link deal.merchant
    end
    column "Venues" do |deal|
      div :class => "venuesCol" do
        deal.venues.map{|v| v.name }.join(", ").html_safe
      end
    end
    column "Start Date", :start_date
    column "Expiry Date", :expiry_date
    column "Multiple Use", :multiple_use
    column "QR Code", :redeemable
    column "Notification pushed", :pushed
    actions
  end

  # SHOW
  show do |f|
    panel "Deal Associations" do
      attributes_table_for f do
        row :merchant_id
        row "Venues" do |deal|
          deal.venues.map{|v| v.name }.join(", ").html_safe
        end
      end
    end

    panel "Deal Info" do
      attributes_table_for f do
        row :title
        row :type_of_deal
        row :description
        row "Terms and Conditions" do
          f.t_c
        end
      end
    end

    panel "Deal Schedule" do
      attributes_table_for f do
        row "Start Date" do
          f.start_date
        end
        row "Expiry Date" do
          f.expiry_date
        end
      end
    end

    panel "Deal Status" do
      attributes_table_for f do
        row "Deal Activated?" do
          f.active ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
        row "Notification Pushed?" do
          f.pushed ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
      end
    end

    panel "Deal Redemption" do
      attributes_table_for f do
        row "Number of Redeems" do
          f.num_of_redeems
        end
        row "Multiple Use?" do
          f.multiple_use ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
      end
    end

    panel "Deal Add-ons" do
      attributes_table_for f do
        row "QR Code Redeemable?" do
          f.redeemable ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
      end
    end
    active_admin_comments # Add this line for comment block
  end

  # EDIT
  form do |f|
    f.inputs "Deal Info" do
      f.input :title
      f.input :type_of_deal, as: :select, collection: ["Discount","Freebies"]
      f.input :description
      f.input :t_c, label: "Terms and Conditions"
    end

=begin
# Admin should NOT be able to edit datetime of deals
    f.inputs "Deal Schedule" do
      f.input :start_date, label: "Start Date", :as => :string
      f.input :expiry_date, label: "Expiry Date", :as => :string
    end
=end

    f.inputs "Deal Status" do
      f.input :active, label: "Deal Activated?"
      f.input :pushed, label: "Notification pushed to users?"
    end

    f.inputs "Deal Redemption" do
      f.input :num_of_redeems, label: "Number of redeems"
      f.input :multiple_use, label: "Multiple Use?"
    end

    f.inputs "Deal Add-ons" do
      f.input :redeemable, label: "QR Code Redeemable?"
    end

    f.actions
  end
end
