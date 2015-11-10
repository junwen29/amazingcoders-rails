ActiveAdmin.register Redemption do
  menu :parent => "Deals", :priority => 2

  config.clear_action_items!
  config.sort_order = "created_at_desc"

  actions :all, except: [:edit]

  action_item :only => :show do
    link_to "Back", "/admin/redemptions"
  end

  scope :all
  scope :dashboard do |redemptions|
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    redemptions.where('created_at >= ? AND created_at <= ?', start_date, end_date)
  end

  filter :deal, label: "Deals", :collection => proc {(Deal.active).map{|d| [d.title, d.id]}}
  filter :user, :collection => proc {(User.all).map{|u| [u.username, u.id]}}
  filter :created_at, label: "Redeemed on"

  index do
    selectable_column
    column :id
    column "Deal", sortable: "deal_id" do |r|
      div :class => "descriptionCol" do
        auto_link r.deal
      end
    end
    column "User", sortable: "user_id" do |r|
      auto_link r.user
    end
    column "Venue", sortable: "venue_id" do |r|
      div :class => "venuesCol" do
        venue = Venue.find_by_id(r.venue_id)
        if venue.present?
          venue.name
        end
      end
    end
    column "Redeemed on", sortable: "created_at" do |r|
      r.created_at.strftime("%B %d, %Y %H:%M")
    end
    actions
  end

  show do |f|
    panel "Deal Redemption" do
      attributes_table_for f do
        row "ID" do
          f.id
        end
        row "Deal Title" do
          f.deal
        end
        row "Merchant" do
          f.deal.merchant
        end
        row "Venue redeemed at" do
          venue = Venue.find_by_id(f.venue_id)
          if venue.present?
            venue.name
          end
        end
        row "User who redeemed" do
          f.user
        end
        row "Redemption time" do
          f.created_at
        end
      end
    end
    active_admin_comments # Add this line for comment block
  end

end
