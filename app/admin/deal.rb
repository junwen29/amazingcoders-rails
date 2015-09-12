ActiveAdmin.register Deal do
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
