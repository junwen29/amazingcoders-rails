class GiftsController < InheritedResources::Base

  def index
    @gifts = Gift.all
    @merchant = Merchant.find(merchant_id)
  end

  def show
    @merchant = Merchant.find(merchant_id)
    points = Merchant.find(merchant_id).total_points
    gift = Gift.find(params[:id])
    if points >= gift.points

      if gift.name == "1 free month"
        @payment = Payment.new
        render 'payments/gift_extend'
        #redirect_to gift_extend_payments_path(@payment)
      else
        flash[:success] = "Gift Redeemed!"
        reason = "Redeemed " + gift.name
        MerchantPointService.new_point(reason, gift.points, "Minus", merchant_id)
        redirect_to merchant_points_path
      end

    else
      flash[:error] = "Insufficient Points!"
      redirect_to gifts_path
    end
  end



  private
  def gift_params
    params.require(:gift).permit(:name, :points, :description, :gift_type)
  end
end

