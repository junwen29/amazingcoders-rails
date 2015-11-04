class Gift < ActiveRecord::Base

  include Gift::Json

  def extend_plan
    flash[:success] = "Gift Redeemed!"
    reason = "Redeemed " + gift.name
    MerchantPointService.new_point(reason, gift.points, "Minus", merchant_id)
  end

  scope :merchant, -> {where("gift_type = ?", 'Merchant')}
  scope :user, -> {where("gift_type = ?", 'User')}

end
