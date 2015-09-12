ActiveAdmin.register Deal do
  permit_params :title, :redeemable, :multiple_use, :image, :type_of_deal, :description, :start_date,
                  :expiry_date, :location, :t_c, :pushed,
                  deal_days_attributes: [:id, :mon, :tue, :wed, :thur, :fri, :sat, :sun, :_destroy,
                                         deal_times_attributes: [:id, :started_at, :ended_at, :_destroy]],
                  deal_venues_attributes: [:id, :qrCodeLink], venues_attributes: [:id, :location]

  scope :active
  scope :waiting
  scope :expired

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

end
