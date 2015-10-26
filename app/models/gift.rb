class Gift < ActiveRecord::Base

  def extend_plan
    flash[:success] = "Gift Redeemed!"
    reason = "Redeemed " + gift.name
    MerchantPointService.new_point(reason, gift.points, "Minus", merchant_id)
  end



end
