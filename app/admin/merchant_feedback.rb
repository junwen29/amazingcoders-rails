ActiveAdmin.register MerchantFeedback do
  config.clear_action_items!

  menu :parent => "Merchant", :priority => 3

  actions :index, :show, :edit

  config.batch_actions = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
