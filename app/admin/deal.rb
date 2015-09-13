ActiveAdmin.register Deal do

  scope :active
  scope :waiting
  scope :expired

  # INDEX
  index do
    selectable_column
    column :id
    column "Title", :title
    column "Type", :type_of_deal
    column "Description", :description
    column "Active Date", :start_date
    column "Expiry Date", :expiry_date
    column "Multiple Use", :multiple_use
    column "QR Code", :redeemable
    column "Push Notification", :pushed
    column "Created At", :created_at
    column "Updated At", :updated_at
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
        row :t_c, label: "Terms and Conditions"
      end
    end

    panel "Deal Schedule" do
      attributes_table_for f do
        row :start_date
        row :expiry_date
      end
    end

    panel "Deal Redemption" do
      attributes_table_for f do
        row :num_of_redeems, label: "Number of Redeems"
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
        row "Push Notification to Wishlist?" do
          f.pushed ? status_tag( "yes", :ok ) : status_tag( "no" )
        end
      end
    end
  end

  # EDIT
  form do |f|
    f.inputs "Deal Info" do
      f.input :title
      f.input :type_of_deal
      f.input :description
      f.input :t_c, label: "Terms and Conditions"
    end

    f.inputs "Deal Schedule" do
      f.input :start_date, label: "Active Date"
      f.input :expiry_date, label: "Expiry Date"
    end

    f.inputs "Deal Redemption" do
      f.input :num_of_redeems, label: "Number of redeems"
      f.input :multiple_use, label: "Multiple Use?"
    end

    f.inputs "Deal Add-ons" do
      f.input :redeemable, label: "QR Code Redeemable?"
      f.input :pushed, label: "Push Notification to Wishlist?"
    end

    f.actions
  end

  # Allow edit
  permit_params :title, :redeemable, :multiple_use, :image, :type_of_deal, :description, :start_date, :expiry_date, :location, :t_c, :pushed,
                deal_days_attributes: [:id, :mon, :tue, :wed, :thur, :fri, :sat, :sun, :_destroy,
                                       deal_times_attributes: [:id, :started_at, :ended_at, :_destroy]],
                deal_venues_attributes: [:id, :qrCodeLink], venues_attributes: [:id, :location]
end
